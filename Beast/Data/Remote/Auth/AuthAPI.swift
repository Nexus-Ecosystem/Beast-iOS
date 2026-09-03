import Foundation

protocol AuthAPIProtocol {
    func login(
        request: LoginRequest
    ) async throws -> LoginResponse
}

final class AuthAPI: AuthAPIProtocol {
    private let networkClient: NetworkClientProtocol
    private let encoder: JSONEncoder

    init(
        networkClient: NetworkClientProtocol = NetworkClient.shared,
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.networkClient = networkClient
        self.encoder = encoder
    }

    func login(
        request: LoginRequest
    ) async throws -> LoginResponse {
        guard let url = URL(
            string: "https://login-rdotx3vmaq-uc.a.run.app"
        ) else {
            throw NetworkError.invalidURL
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

        urlRequest.httpBody = try encoder.encode(request)

        return try await networkClient.execute(
            urlRequest,
            responseType: LoginResponse.self
        )
    }
}
