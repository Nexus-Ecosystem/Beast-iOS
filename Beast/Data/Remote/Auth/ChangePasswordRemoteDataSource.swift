import Foundation

protocol ChangePasswordRemoteDataSourceProtocol {
    func changePassword(
        request: ChangePasswordRequest
    ) async throws -> ChangePasswordResponse
}

final class ChangePasswordRemoteDataSource:
    ChangePasswordRemoteDataSourceProtocol
{
    private let session: URLSession

    private let endpoint =
        "https://changepassword-rdotx3vmaq-uc.a.run.app"

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func changePassword(
        request: ChangePasswordRequest
    ) async throws -> ChangePasswordResponse {
        guard let url = URL(string: endpoint) else {
            throw ChangePasswordRemoteError.invalidURL
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

        urlRequest.httpBody = try JSONEncoder().encode(
            request
        )

        NetworkLogger.logRequest(
            urlRequest
        )

        let startTime = Date()

        do {
            let (data, response) = try await session.data(
                for: urlRequest
            )

            guard let httpResponse =
                response as? HTTPURLResponse
            else {
                throw ChangePasswordRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(startTime)
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                let backendResponse =
                    try? JSONDecoder().decode(
                        ChangePasswordResponse.self,
                        from: data
                    )

                if let error = backendResponse?.error,
                   !error.isEmpty {
                    throw ChangePasswordRemoteError.backendError(
                        error
                    )
                }

                throw ChangePasswordRemoteError.httpError(
                    httpResponse.statusCode
                )
            }

            do {
                return try JSONDecoder().decode(
                    ChangePasswordResponse.self,
                    from: data
                )
            } catch {
                throw ChangePasswordRemoteError.decodingError(
                    error.localizedDescription
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
}

enum ChangePasswordRemoteError:
    LocalizedError
{
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case backendError(String)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL para cambiar la contraseña no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case let .httpError(code):
            return "No fue posible cambiar la contraseña. Código \(code)."

        case let .backendError(message):
            return message

        case let .decodingError(message):
            return "No fue posible leer la respuesta: \(message)"
        }
    }
}
