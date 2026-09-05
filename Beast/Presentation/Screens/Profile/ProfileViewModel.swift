import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var profile: ProfileDisplayModel = .empty
    @Published private(set) var isLoading = false

    @Published var showLogoutConfirmation = false
    @Published var errorMessage: String?

    private let useCase: ProfileUseCase

    private var didStart = false

    init(
        useCase: ProfileUseCase = ProfileUseCase()
    ) {
        self.useCase = useCase
    }

    func onAppear() {
        guard !didStart else {
            return
        }

        didStart = true
        isLoading = true
        errorMessage = nil

        guard let localProfile = useCase.localProfile() else {
            isLoading = false
            errorMessage =
                "No se encontró la información del usuario."
            return
        }

        guard !localProfile.email.isEmpty else {
            isLoading = false
            errorMessage =
                "No se encontró el correo del usuario."
            return
        }

        loadInitialProfile(
            localProfile
        )

        subscribe(
            email: localProfile.email
        )
    }

    func requestLogout() {
        showLogoutConfirmation = true
    }

    func cancelLogout() {
        showLogoutConfirmation = false
    }

    func confirmLogout() {
        showLogoutConfirmation = false
        isLoading = true

        useCase.logout()

        isLoading = false
    }

    func resetError() {
        errorMessage = nil
    }

    func stop() {
        didStart = false
        useCase.stopProfileObserver()
    }

    private func subscribe(
        email: String
    ) {
        useCase.observeProfile(
            email: email,
            onChange: { [weak self] profile in
                guard let self else {
                    return
                }

                self.profile = profile
                self.isLoading = false
            },
            onError: { [weak self] error in
                guard let self else {
                    return
                }

                self.isLoading = false
                self.errorMessage =
                    error.localizedDescription
            }
        )
    }

    private func loadInitialProfile(
        _ profile: AllDataProfileUserSystem
    ) {
        self.profile = ProfileDisplayModel(
            fullName: profile.fullName,
            email: profile.email,
            phone: profile.phone,
            photoURL:
                profile.fotoPerfil.isEmpty
                ? profile.urlPhoto
                : profile.fotoPerfil,
            packageId: "",
            packageName:
                profile.membershipName,
            packageExpiration:
                profile.fechaPago,
            packageType: 0,
            classesTaken: 0,
            totalClasses: 0,
            extraCredits: 0,
            responsiveSigned:
                profile.responsiveSigned,
            responsiveURL:
                profile.urlDocumentResponsiva
        )
    }
}
