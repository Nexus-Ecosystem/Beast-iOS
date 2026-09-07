import Foundation

final class ProfileEditUseCase {
    private let repository: ProfileEditRepository

    init(
        repository:
            ProfileEditRepository =
                ProfileEditRepositoryImpl()
    ) {
        self.repository = repository
    }

    func updateProfile(
        email: String,
        fullName: String,
        phone: String
    ) async throws {
        try await repository
            .updateProfile(
                email: email,
                fullName: fullName,
                phone: phone
            )
    }

    func uploadProfileImage(
        email: String,
        imageData: Data
    ) async throws -> String {
        try await repository
            .uploadProfileImage(
                email: email,
                imageData: imageData
            )
    }

    func updateProfileImage(
        email: String,
        imageURL: String
    ) async throws {
        try await repository
            .updateProfileImage(
                email: email,
                imageURL: imageURL
            )
    }
}
