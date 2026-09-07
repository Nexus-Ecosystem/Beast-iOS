import Foundation
import Combine

enum VerificationMode {
    case registration
    case passwordRecovery
}

@MainActor
final class VerificationViewModel:
    ObservableObject
{
    @Published var otp = ""

    @Published private(set)
    var isLoading = false

    @Published var showError = false

    @Published var showSuccess = false

    @Published private(set)
    var errorMessage = ""

    @Published private(set)
    var registrationCompleted = false

    @Published private(set)
    var passwordOtpVerified = false

    let user:
        RegistrationUser

    let mode:
        VerificationMode

    private let useCase:
        RegistrationUseCase

    init(
        user: RegistrationUser,
        mode: VerificationMode,
        useCase:
            RegistrationUseCase =
                RegistrationUseCase()
    ) {
        self.user = user
        self.mode = mode
        self.useCase = useCase
    }

    var isOtpComplete:
        Bool
    {
        otp.count == 6
    }

    func updateOtp(
        _ value: String
    ) {
        let filtered =
            value.filter {
                $0.isNumber
            }

        otp =
            String(
                filtered.prefix(6)
            )
    }

    func verify() async {
        guard isOtpComplete else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let verified =
                try await useCase.verifyOtp(
                    email: user.email,
                    otp: otp
                )

            guard verified else {
                presentError(
                    "El código ingresado no es válido."
                )
                return
            }

            switch mode {
            case .registration:
                try await register()

            case .passwordRecovery:
                passwordOtpVerified = true
            }
        } catch {
            presentError(
                error.localizedDescription
            )
        }
    }

    func resendOtp() async {
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let result =
                try await useCase.sendOtp(
                    email: user.email
                )

            guard result else {
                presentError(
                    "No fue posible reenviar el código."
                )
                return
            }
        } catch {
            presentError(
                error.localizedDescription
            )
        }
    }

    private func register() async throws {
        let response =
            try await useCase.register(
                user: user
            )

        guard !response.email.isEmpty else {
            throw RegistrationRepositoryError.backend(
                response.error.isEmpty
                    ? "No fue posible crear la cuenta."
                    : response.error
            )
        }

        registrationCompleted = true
        showSuccess = true
    }

    func closeError() {
        showError = false
    }

    private func presentError(
        _ message: String
    ) {
        errorMessage = message
        showError = true
    }
}
