import Foundation

protocol NetworkClientProtocol {
    func execute<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    static let shared = NetworkClient()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func execute<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        NetworkLogger.logRequest(request)

        let startTime = Date()

        do {
            let (data, response) = try await session.data(
                for: request
            )

            let duration = Date().timeIntervalSince(startTime)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: request,
                response: httpResponse,
                data: data,
                duration: duration
            )

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(
                    statusCode: httpResponse.statusCode,
                    data: data
                )
            }

            do {
                return try decoder.decode(
                    responseType,
                    from: data
                )
            } catch {
                #if DEBUG
                print("")
                print("❌ DECODING ERROR")
                print("Type: \(String(describing: responseType))")
                print("Error: \(error)")
                print("")
                #endif

                throw NetworkError.decoding(error)
            }

        } catch let error as NetworkError {
            NetworkLogger.logError(
                request: request,
                error: error
            )

            throw error

        } catch {
            NetworkLogger.logError(
                request: request,
                error: error
            )

            throw NetworkError.transport(error)
        }
    }
}
