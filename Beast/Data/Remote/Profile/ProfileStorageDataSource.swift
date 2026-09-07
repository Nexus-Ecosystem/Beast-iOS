import Foundation
import FirebaseStorage

protocol ProfileStorageDataSourceProtocol {
    func uploadProfileImage(
        email: String,
        imageData: Data
    ) async throws -> String
}

final class ProfileStorageDataSource:
    ProfileStorageDataSourceProtocol
{
    private let storage: Storage

    init(
        storage: Storage = Storage.storage()
    ) {
        self.storage = storage
    }

    func uploadProfileImage(
        email: String,
        imageData: Data
    ) async throws -> String {
        let reference = storage
            .reference()
            .child(
                "perfil_usuarios/\(email).jpg"
            )

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await reference.putDataAsync(
            imageData,
            metadata: metadata
        )

        let url = try await reference.downloadURL()

        return url.absoluteString
    }
}
