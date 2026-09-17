import Foundation

struct SendOTPRequest: Codable {
    let email: String
}

struct SendOTPResponse: Codable {
    let success: Bool
}

protocol SendOTPRemoteDataSourceProtocol {
    func sendOTP(
        request: SendOTPRequest
    ) async throws -> SendOTPResponse
}

final class SendOTPRemoteDataSource:
    SendOTPRemoteDataSourceProtocol
{
    private let session: URLSession

    private var endpoint: String {
        AppConfiguration.serviceURL("sendotp")
    }

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func sendOTP(
        request: SendOTPRequest
    ) async throws -> SendOTPResponse {
        guard let url = URL(string: endpoint) else {
            throw SendOTPRemoteError.invalidURL
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

        urlRequest.httpBody = try JSONEncoder()
            .encode(request)

        NetworkLogger.logRequest(
            urlRequest
        )

        let startTime = Date()

        do {
            let (data, response) =
                try await session.data(
                    for: urlRequest
                )

            guard let httpResponse =
                response as? HTTPURLResponse
            else {
                throw SendOTPRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date()
                    .timeIntervalSince(startTime)
            )

            guard 200..<300 ~=
                    httpResponse.statusCode
            else {
                throw SendOTPRemoteError.httpError(
                    httpResponse.statusCode
                )
            }

            let result: SendOTPResponse

            do {
                result = try JSONDecoder()
                    .decode(
                        SendOTPResponse.self,
                        from: data
                    )
            } catch {
                throw SendOTPRemoteError.decodingError(
                    error.localizedDescription
                )
            }

            guard result.success else {
                throw SendOTPRemoteError.sendFailed
            }

            return result

        } catch {
            NetworkLogger.logError(
                request: urlRequest,
                error: error
            )

            throw error
        }
    }
}

enum SendOTPRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case sendFailed
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL para enviar el código no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case let .httpError(code):
            return "No fue posible enviar el código. Código \(code)."

        case .sendFailed:
            return "No fue posible enviar el código."

        case let .decodingError(message):
            return "No fue posible leer la respuesta: \(message)"
        }
    }
}
