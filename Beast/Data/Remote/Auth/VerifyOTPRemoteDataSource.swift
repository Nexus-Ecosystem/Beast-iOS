import Foundation

struct VerifyOTPRequest: Codable {
    let email: String
    let otp: String
}

struct VerifyOTPResponse: Codable {
    let verified: Bool
}

protocol VerifyOTPRemoteDataSourceProtocol {
    func verifyOTP(
        request: VerifyOTPRequest
    ) async throws -> VerifyOTPResponse
}

final class VerifyOTPRemoteDataSource:
    VerifyOTPRemoteDataSourceProtocol
{
    private let session: URLSession

    private var endpoint: String {
        AppConfiguration.serviceURL("verifyotp")
    }

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func verifyOTP(
        request: VerifyOTPRequest
    ) async throws -> VerifyOTPResponse {
        guard let url = URL(string: endpoint) else {
            throw VerifyOTPRemoteError.invalidURL
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
                throw VerifyOTPRemoteError.invalidResponse
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
                throw VerifyOTPRemoteError.httpError(
                    httpResponse.statusCode
                )
            }

            let result: VerifyOTPResponse

            do {
                result = try JSONDecoder()
                    .decode(
                        VerifyOTPResponse.self,
                        from: data
                    )
            } catch {
                throw VerifyOTPRemoteError.decodingError(
                    error.localizedDescription
                )
            }

            guard result.verified else {
                throw VerifyOTPRemoteError.invalidOTP
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

enum VerifyOTPRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidOTP
    case httpError(Int)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL para validar el código no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case .invalidOTP:
            return "El código de verificación no es válido."

        case let .httpError(code):
            return "No fue posible validar el código. Código \(code)."

        case let .decodingError(message):
            return "No fue posible leer la respuesta: \(message)"
        }
    }
}
