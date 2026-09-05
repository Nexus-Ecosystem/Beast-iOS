import Foundation

final class ProfileUseCase {
    private let repository: ProfileRepository

    init(
        repository: ProfileRepository = ProfileRepositoryImpl()
    ) {
        self.repository = repository
    }

    func localProfile() -> AllDataProfileUserSystem? {
        repository.localProfile()
    }

    func observeProfile(
        email: String,
        onChange: @escaping (ProfileDisplayModel) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        repository.observeProfile(
            email: email,
            onChange: onChange,
            onError: onError
        )
    }

    func stopProfileObserver() {
        repository.stopProfileObserver()
    }

    func logout() {
        repository.logout()
    }
}
