import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let api: AuthAPIProtocol

    init(api: AuthAPIProtocol = AuthAPI()) {
        self.api = api
    }

    func login(
        email: String,
        password: String,
        tokenFirebase: String
    ) async throws -> LoginResponse {
        let request = LoginRequest(
            email: email,
            password: password,
            tokenFirebase: tokenFirebase
        )

        return try await api.login(request: request)
    }
}
