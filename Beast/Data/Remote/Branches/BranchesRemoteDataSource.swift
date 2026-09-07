import Foundation

protocol BranchesRemoteDataSourceProtocol {
    func subscribe(
        email: String,
        branchId: String
    ) async throws -> Bool
}

final class BranchesRemoteDataSource: BranchesRemoteDataSourceProtocol {
    private let session: URLSession

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func subscribe(
        email: String,
        branchId: String
    ) async throws -> Bool {
        guard let url = URL(
            string: RegistrationEndpoints.subscribeUserToBranch
        ) else {
            throw BranchesRemoteError.invalidURL
        }

        let requestBody = RegisterUserToBranchRequest(
            email: email,
            idBranch: branchId
        )

        var request = URLRequest(
            url: url
        )

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        request.httpBody = try JSONEncoder().encode(
            requestBody
        )

        NetworkLogger.logRequest(
            request
        )

        let startTime = Date()

        do {
            let (data, response) = try await session.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw BranchesRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: request,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(
                    startTime
                )
            )

            if 200..<300 ~= httpResponse.statusCode {
                let responseModel = try JSONDecoder().decode(
                    RegisterUserToBranchResponse.self,
                    from: data
                )

                guard responseModel.success else {
                    throw BranchesRemoteError.backend(
                        responseModel.error.isEmpty
                            ? "No fue posible suscribirse al estudio."
                            : responseModel.error
                    )
                }

                return true
            }

            let message = backendMessage(
                from: data
            )

            if isAlreadySubscribed(
                message
            ) {
                return true
            }

            if !message.isEmpty {
                throw BranchesRemoteError.backend(
                    message
                )
            }

            throw BranchesRemoteError.httpError(
                httpResponse.statusCode
            )

        } catch {
            NetworkLogger.logError(
                request: request,
                error: error
            )

            throw error
        }
    }

    private func isAlreadySubscribed(
        _ message: String
    ) -> Bool {
        let normalized = message
            .folding(
                options: [
                    .diacriticInsensitive,
                    .caseInsensitive
                ],
                locale: .current
            )
            .lowercased()

        return normalized.contains(
            "ya esta suscrito"
        )
    }

    private func backendMessage(
        from data: Data
    ) -> String {
        guard let object = try? JSONSerialization
            .jsonObject(
                with: data
            ) as? [String: Any]
        else {
            return ""
        }

        if let error = object["error"] as? String {
            return error
        }

        if let message = object["message"] as? String {
            return message
        }

        return ""
    }
}

enum BranchesRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case backend(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL del servicio no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case let .httpError(code):
            return "No fue posible suscribirse al estudio. Código \(code)."

        case let .backend(message):
            return message
        }
    }
}
