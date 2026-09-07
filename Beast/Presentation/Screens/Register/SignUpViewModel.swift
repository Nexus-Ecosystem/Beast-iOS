import Foundation
import Combine

@MainActor
final class SignUpViewModel:
    ObservableObject
{
    @Published var fullName = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var passwordVisible = false
    @Published var confirmPasswordVisible = false

    @Published private(set)
    var isLoading = false

    @Published var showError = false

    @Published private(set)
    var errorMessage = ""

    private let useCase:
        RegistrationUseCase

    init(
        useCase:
            RegistrationUseCase =
                RegistrationUseCase()
    ) {
        self.useCase =
            useCase
    }

    var hasUppercase: Bool {
        password.contains {
            $0.isUppercase
        }
    }

    var hasNumber: Bool {
        password.contains {
            $0.isNumber
        }
    }

    var hasSpecialCharacter: Bool {
        password.contains {
            !$0.isLetter &&
            !$0.isNumber
        }
    }

    var hasMinLength: Bool {
        password.count >= 8
    }

    var passwordsMatch: Bool {
        !password.isEmpty &&
        password == confirmPassword
    }

    var securityScore: Int {
        [
            hasUppercase,
            hasNumber,
            hasSpecialCharacter,
            hasMinLength
        ]
        .filter { $0 }
        .count
    }

    var isFormValid: Bool {
        !fullName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty &&
        !email
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty &&
        securityScore == 4 &&
        passwordsMatch &&
        !isLoading
    }

    var user: RegistrationUser {
        RegistrationUser(
            email:
                email.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ),
            password: password,
            fullName:
                fullName.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ),
            phone:
                phone.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
        )
    }

    func sendOtp() async -> Bool {
        guard isFormValid else {
            return false
        }

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
                    "No fue posible enviar el código de verificación."
                )
                return false
            }

            return true
        } catch {
            presentError(
                error.localizedDescription
            )
            return false
        }
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
