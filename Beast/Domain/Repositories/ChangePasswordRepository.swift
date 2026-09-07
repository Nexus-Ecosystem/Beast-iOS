import Foundation

protocol ChangePasswordRepository {
    func changePassword(
        email: String,
        newPassword: String
    ) async throws -> Bool
}
