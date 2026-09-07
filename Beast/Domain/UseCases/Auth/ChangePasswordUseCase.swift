import Foundation

final class ChangePasswordUseCase {
    private let repository:
        ChangePasswordRepository

    init(
        repository:
            ChangePasswordRepository =
                ChangePasswordRepositoryImpl()
    ) {
        self.repository =
            repository
    }

    func execute(
        email: String,
        newPassword: String
    ) async throws -> Bool {
        try await repository.changePassword(
            email: email,
            newPassword: newPassword
        )
    }
}
