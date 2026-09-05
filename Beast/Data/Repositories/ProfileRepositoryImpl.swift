import Foundation
import FirebaseFirestore

final class ProfileRepositoryImpl: ProfileRepository {
    private let firebaseDataSource: ProfileFirebaseDataSourceProtocol
    private let storage: AppStorageManager

    private var profileListener: ListenerRegistration?

    init(
        firebaseDataSource: ProfileFirebaseDataSourceProtocol = ProfileFirebaseDataSource(),
        storage: AppStorageManager = .shared
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.storage = storage
    }

    func observeProfile(
        email: String,
        onChange: @escaping (ProfileDisplayModel) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        profileListener?.remove()

        profileListener =
            firebaseDataSource.observeProfile(
                email: email,
                onChange: onChange,
                onError: onError
            )
    }

    func stopProfileObserver() {
        profileListener?.remove()
        profileListener = nil
    }

    func localProfile() -> AllDataProfileUserSystem? {
        storage.getProfile()
    }

    func logout() {
        storage.clearSession()
    }

    deinit {
        profileListener?.remove()
    }
}
