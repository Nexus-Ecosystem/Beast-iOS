import Foundation

protocol BikeSelectionRemoteDataSourceProtocol {
    func reserveBike(
        request: ApartarMobiliarioRequest
    ) async throws -> ApartarMobiliarioResponse
}

final class BikeSelectionRemoteDataSource: BikeSelectionRemoteDataSourceProtocol {
    private let session: URLSession

    private let endpoint = URL(
        string: "https://apartarmobiliario-rdotx3vmaq-uc.a.run.app"
    )!

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func reserveBike(
        request: ApartarMobiliarioRequest
    ) async throws -> ApartarMobiliarioResponse {
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

        let startedAt = Date()

        do {
            let (data, response) = try await session.data(
                for: urlRequest
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw BikeSelectionError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(
                    startedAt
                )
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                let backendResponse = try? JSONDecoder().decode(
                    ApartarMobiliarioResponse.self,
                    from: data
                )

                throw BikeSelectionError.backend(
                    backendResponse?.message ??
                    "No fue posible seleccionar la bicicleta."
                )
            }

            return try JSONDecoder().decode(
                ApartarMobiliarioResponse.self,
                from: data
            )

        } catch let error as BikeSelectionError {
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

enum BikeSelectionError: LocalizedError {
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
