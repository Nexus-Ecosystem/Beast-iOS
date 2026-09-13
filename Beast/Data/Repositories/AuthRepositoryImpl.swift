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
        guard
            let encryptedEmail = CryptoManager.encryptString(email),
            let encryptedPassword = CryptoManager.encryptString(password)
        else {
            throw AuthRepositoryError.encryptionFailed
        }

        let request = LoginRequest(
            email: encryptedEmail,
            password: encryptedPassword,
            tokenFirebase: tokenFirebase
        )

        return try await api.login(request: request)
    }
}

enum AuthRepositoryError: LocalizedError {
    case encryptionFailed

    var errorDescription: String? {
        switch self {
        case .encryptionFailed:
            return "No fue posible proteger las credenciales."
        }
    }
}
