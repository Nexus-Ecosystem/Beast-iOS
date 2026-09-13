import Foundation

protocol DeleteAccountUseCaseProtocol {
    func execute(
        email: String
    ) async throws
}

final class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    private let repository: DeleteAccountRepository

    init(
        repository: DeleteAccountRepository = DeleteAccountRepositoryImpl()
    ) {
        self.repository = repository
    }

    func execute(
        email: String
    ) async throws {
        let normalizedEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !normalizedEmail.isEmpty else {
            throw DeleteAccountUseCaseError.missingEmail
        }

        try await repository.deleteAccount(
            email: normalizedEmail
        )
    }
}

enum DeleteAccountUseCaseError: LocalizedError {
    case missingEmail

    var errorDescription: String? {
        switch self {
        case .missingEmail:
            return "No se encontró el correo asociado a tu cuenta."
        }
    }
}
