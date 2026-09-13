import Foundation

protocol RegistrationRemoteDataSourceProtocol {
    func sendOtp(
        request: SendOtpRequest
    ) async throws -> SendOtpResponse

    func verifyOtp(
        request: VerifyOtpRequest
    ) async throws -> VerifyOtpResponse

    func register(
        request: RegisterRequest
    ) async throws -> RegisterResponse
}

final class RegistrationRemoteDataSource:
    RegistrationRemoteDataSourceProtocol
{
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func sendOtp(
        request: SendOtpRequest
    ) async throws -> SendOtpResponse {
        try await perform(
            endpoint: RegistrationEndpoints.sendOtp,
            body: request,
            responseType: SendOtpResponse.self
        )
    }

    func verifyOtp(
        request: VerifyOtpRequest
    ) async throws -> VerifyOtpResponse {
        try await perform(
            endpoint: RegistrationEndpoints.verifyOtp,
            body: request,
            responseType: VerifyOtpResponse.self
        )
    }

    func register(
        request: RegisterRequest
    ) async throws -> RegisterResponse {
        guard let encryptedPassword = CryptoManager.encryptString(
            request.password
        ) else {
            throw RegistrationRemoteError.encryptionFailed
        }

        let encryptedRequest = RegisterRequest(
            email: request.email,
            password: encryptedPassword,
            fullName: request.fullName,
            phone: request.phone,
            tokenFirebase: request.tokenFirebase
        )

        return try await perform(
            endpoint: RegistrationEndpoints.register,
            body: encryptedRequest,
            responseType: RegisterResponse.self
        )
    }

    private func perform<Request: Encodable, Response: Decodable>(
        endpoint: String,
        body: Request,
        responseType: Response.Type
    ) async throws -> Response {
        guard let url = URL(string: endpoint) else {
            throw RegistrationRemoteError.invalidURL
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
        urlRequest.httpBody = try JSONEncoder().encode(body)

        NetworkLogger.logRequest(urlRequest)

        let startTime = Date()

        do {
            let (data, response) = try await session.data(
                for: urlRequest
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw RegistrationRemoteError.invalidResponse
            }

            NetworkLogger.logResponse(
                request: urlRequest,
                response: httpResponse,
                data: data,
                duration: Date().timeIntervalSince(startTime)
            )

            guard 200..<300 ~= httpResponse.statusCode else {
                throw RegistrationRemoteError.httpError(
                    httpResponse.statusCode,
                    backendMessage(from: data)
                )
            }

            do {
                return try JSONDecoder().decode(
                    responseType,
                    from: data
                )
            } catch {
                throw RegistrationRemoteError.decodingError(
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

    private func backendMessage(from data: Data) -> String {
        guard
            let object = try? JSONSerialization.jsonObject(
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

enum RegistrationRemoteError: LocalizedError {
    case invalidURL
    case invalidResponse
    case encryptionFailed
    case httpError(Int, String)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL del servicio no es válida."

        case .invalidResponse:
            return "La respuesta del servidor no es válida."

        case .encryptionFailed:
            return "No fue posible proteger la contraseña."

        case let .httpError(code, message):
            return message.isEmpty
                ? "No fue posible completar la operación. Código \(code)."
                : message

        case let .decodingError(message):
            return "No fue posible leer la respuesta: \(message)"
        }
    }
}
