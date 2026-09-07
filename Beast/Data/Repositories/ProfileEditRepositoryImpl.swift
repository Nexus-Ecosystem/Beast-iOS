import Foundation

final class ProfileEditRepositoryImpl:
    ProfileEditRepository
{
    private let firebaseDataSource:
        ProfileEditFirebaseDataSourceProtocol

    private let storageDataSource:
        ProfileStorageDataSourceProtocol

    init(
        firebaseDataSource:
            ProfileEditFirebaseDataSourceProtocol =
                ProfileEditFirebaseDataSource(),
        storageDataSource:
            ProfileStorageDataSourceProtocol =
                ProfileStorageDataSource()
    ) {
        self.firebaseDataSource =
            firebaseDataSource

        self.storageDataSource =
            storageDataSource
    }

    func updateProfile(
        email: String,
        fullName: String,
        phone: String
    ) async throws {
        try await firebaseDataSource
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
        try await storageDataSource
            .uploadProfileImage(
                email: email,
                imageData: imageData
            )
    }

    func updateProfileImage(
        email: String,
        imageURL: String
    ) async throws {
        try await firebaseDataSource
            .updateProfileImage(
                email: email,
                imageURL: imageURL
            )
    }
}
