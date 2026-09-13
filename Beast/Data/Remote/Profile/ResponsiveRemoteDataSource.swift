import Foundation

protocol ResponsiveRemoteDataSourceProtocol {
    func signResponsive(
        request: ResponsiveRequest
    ) async throws -> ResponsiveResponse
}

final class ResponsiveRemoteDataSource:
    ResponsiveRemoteDataSourceProtocol
{
    private let session: URLSession

    private var endpoint: String {
        AppConfiguration.serviceURL("generarpdffirma")
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func signResponsive(
        request: ResponsiveRequest
    ) async throws -> ResponsiveResponse {
        guard let url = URL(string: endpoint) else {
            throw ResponsiveRemoteError.invalidURL
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
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ResponsiveRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(startTime)
            )

            let decodedResponse: ResponsiveResponse

            do {
                decodedResponse = try JSONDecoder().decode(
                    ResponsiveResponse.self,
                    from: data
                )
            } catch {
                throw ResponsiveRemoteError.decodingError(
                    error.localizedDescription
                )
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                if !decodedResponse.error.isEmpty {
                    throw ResponsiveRemoteError.backendError(
                        decodedResponse.error
                    )
                }

                throw ResponsiveRemoteError.httpError(
                    httpResponse.statusCode
                )
            }

            return decodedResponse
        } catch {
            NetworkLogger.logError(
                request: urlRequest,
                error: error
            )

            throw error
        }
    }
}

enum ResponsiveRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case backendError(String)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL de responsiva no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case let .httpError(code):
            return "No fue posible firmar la responsiva. Código \(code)."

        case let .backendError(message):
            return message

        case let .decodingError(message):
            return "No fue posible leer la respuesta: \(message)"
        }
    }
}
