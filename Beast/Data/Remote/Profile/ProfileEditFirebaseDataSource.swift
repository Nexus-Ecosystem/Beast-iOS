import Foundation
import FirebaseFirestore

protocol ProfileEditFirebaseDataSourceProtocol {
    func updateProfile(
        email: String,
        fullName: String,
        phone: String
    ) async throws

    func updateProfileImage(
        email: String,
        imageURL: String
    ) async throws
}

final class ProfileEditFirebaseDataSource:
    ProfileEditFirebaseDataSourceProtocol
{
    private let firestore: Firestore

    init(
        firestore: Firestore = Firestore.firestore()
    ) {
        self.firestore = firestore
    }

    func updateProfile(
        email: String,
        fullName: String,
        phone: String
    ) async throws {
        let path = "users/\(email)"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "UPDATE"
        )

        do {
            try await firestore
                .collection("users")
                .document(email)
                .updateData([
                    "fullName": fullName,
                    "phone": phone
                ])
        } catch {
            NetworkLogger.logFirebaseError(
                path: path,
                error: error
            )

            throw error
        }
    }

    func updateProfileImage(
        email: String,
        imageURL: String
    ) async throws {
        let path = "users/\(email)"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "UPDATE"
        )

        do {
            try await firestore
                .collection("users")
                .document(email)
                .updateData([
                    "fotoPerfil": imageURL
                ])
        } catch {
            NetworkLogger.logFirebaseError(
                path: path,
                error: error
            )

            throw error
        }
    }
}
