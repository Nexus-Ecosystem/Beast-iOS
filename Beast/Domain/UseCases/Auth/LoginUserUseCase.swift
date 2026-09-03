import Foundation

struct LoginUserUseCase {
    private let repository: AuthRepository

    init(
        repository: AuthRepository = AuthRepositoryImpl()
    ) {
        self.repository = repository
    }

    func execute(
        email: String,
        password: String,
        tokenFirebase: String
    ) async throws -> LoginResponse {
        try await repository.login(
            email: email,
            password: password,
            tokenFirebase: tokenFirebase
        )
    }
}
