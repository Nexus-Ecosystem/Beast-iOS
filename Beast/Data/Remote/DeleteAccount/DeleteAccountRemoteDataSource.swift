import Foundation

protocol DeleteAccountRemoteDataSourceProtocol {
    func deleteAccount(
        request: DeleteAccountRequest
    ) async throws
}

final class DeleteAccountRemoteDataSource: DeleteAccountRemoteDataSourceProtocol {
    private let session: URLSession

    private var endpoint: String {
        AppConfiguration.serviceURL("deleteaccountuser")
    }

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func deleteAccount(
        request: DeleteAccountRequest
    ) async throws {
        guard let url = URL(string: endpoint) else {
            throw DeleteAccountRemoteError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )
        urlRequest.httpBody = try JSONEncoder().encode(request)

        NetworkLogger.logRequest(urlRequest)

        let startTime = Date()

        do {
            let (data, response) = try await session.data(
                for: urlRequest
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw DeleteAccountRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(startTime)
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                if let backendError = decodeBackendError(
                    from: data
                ) {
                    throw DeleteAccountRemoteError.backendError(
                        backendError
                    )
                }

                throw DeleteAccountRemoteError.httpError(
                    httpResponse.statusCode
                )
            }
        } catch {
            NetworkLogger.logError(
                request: urlRequest,
                error: error
            )

            throw error
        }
    }

    private func decodeBackendError(
        from data: Data
    ) -> String? {
        guard !data.isEmpty else {
            return nil
        }

        guard let response = try? JSONDecoder().decode(
            DeleteAccountBackendError.self,
            from: data
        ) else {
            return nil
        }

        if let message = response.message,
           !message.isEmpty {
            return message
        }

        if let error = response.error,
           !error.isEmpty {
            return error
        }

        return nil
    }
}

private struct DeleteAccountBackendError: Decodable {
    let message: String?
    let error: String?
}

enum DeleteAccountRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case backendError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL para eliminar la cuenta no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case let .httpError(code):
            return "No fue posible eliminar tu cuenta. Código \(code)."

        case let .backendError(message):
            return message
        }
    }
}
