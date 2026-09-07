import Foundation

protocol ProfileEditRepository {
    func updateProfile(
        email: String,
        fullName: String,
        phone: String
    ) async throws

    func uploadProfileImage(
        email: String,
        imageData: Data
    ) async throws -> String

    func updateProfileImage(
        email: String,
        imageURL: String
    ) async throws
}
