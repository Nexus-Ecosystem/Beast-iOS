import Foundation

protocol NotificationsRemoteDataSourceProtocol {
    func getNotifications(
        request: NotificationsRequest
    ) async throws -> NotificationsResponse
}

final class NotificationsRemoteDataSource:
    NotificationsRemoteDataSourceProtocol
{
    private let session: URLSession

    private var endpoint: String {
        AppConfiguration.serviceURL("getnotifications")
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getNotifications(
        request: NotificationsRequest
    ) async throws -> NotificationsResponse {
        guard let url = URL(string: endpoint) else {
            throw NotificationsRemoteError.invalidURL
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
                throw NotificationsRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(startTime)
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NotificationsRemoteError.httpError(
                    httpResponse.statusCode
                )
            }

            do {
                return try JSONDecoder().decode(
                    NotificationsResponse.self,
                    from: data
                )
            } catch {
                throw NotificationsRemoteError.decodingError(
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

enum NotificationsRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL de notificaciones no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case let .httpError(code):
            return "Error al obtener notificaciones. Código \(code)."

        case let .decodingError(message):
            return "No fue posible leer las notificaciones: \(message)"
        }
    }
}
