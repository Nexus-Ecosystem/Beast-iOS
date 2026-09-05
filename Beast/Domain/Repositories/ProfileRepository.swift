import Foundation

protocol ProfileRepository {
    func observeProfile(
        email: String,
        onChange: @escaping (ProfileDisplayModel) -> Void,
        onError: @escaping (Error) -> Void
    )

    func stopProfileObserver()

    func localProfile() -> AllDataProfileUserSystem?

    func logout()
}
