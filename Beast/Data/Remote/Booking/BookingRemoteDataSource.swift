import Foundation

protocol BookingRemoteDataSourceProtocol {
    func bookingClass(
        request: BookingClassRequest
    ) async throws -> BookingClassResponse
}

final class BookingRemoteDataSource: BookingRemoteDataSourceProtocol {
    private let session: URLSession

    private let endpoint = URL(
        string: "https://agendarclase-rdotx3vmaq-uc.a.run.app"
    )!

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func bookingClass(
        request: BookingClassRequest
    ) async throws -> BookingClassResponse {
        var urlRequest = URLRequest(
            url: endpoint
        )

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
            let (
                data,
                response
            ) = try await session.data(
                for: urlRequest
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw BookingRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(
                    startTime
                )
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                let backendMessage = try? JSONDecoder()
                    .decode(
                        BookingClassResponse.self,
                        from: data
                    )
                    .message

                throw BookingRemoteError.backend(
                    backendMessage ??
                    "No fue posible realizar la operación."
                )
            }

            if data.isEmpty {
                return BookingClassResponse(
                    success: true,
                    message: nil
                )
            }

            return try JSONDecoder().decode(
                BookingClassResponse.self,
                from: data
            )
        } catch let error as BookingRemoteError {
            throw error
        } catch {
            NetworkLogger.logError(
                request: urlRequest,
                error: error
            )

            throw error
        }
    }
}

enum BookingRemoteError: LocalizedError {
    case invalidResponse
    case backend(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case .backend(let message):
            return message
        }
    }
}
