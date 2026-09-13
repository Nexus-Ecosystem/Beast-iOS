import Foundation

protocol DeleteAccountRepository {
    func deleteAccount(
        email: String
    ) async throws
}
