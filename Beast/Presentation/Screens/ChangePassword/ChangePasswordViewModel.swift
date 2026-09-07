import Foundation
import Combine

@MainActor
final class ChangePasswordViewModel: ObservableObject {
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published private(set) var isLoading = false
    @Published var showSuccess = false
    @Published var showError = false
    @Published private(set) var errorMessage = ""

    let email: String

    private let useCase: ChangePasswordUseCase
    private let profileUseCase: ProfileUseCase

    init(
        email: String,
        useCase: ChangePasswordUseCase = ChangePasswordUseCase(),
        profileUseCase: ProfileUseCase = ProfileUseCase()
    ) {
        self.email = email
        self.useCase = useCase
        self.profileUseCase = profileUseCase
    }

    var hasMinLength: Bool {
        password.count >= 8
    }

    var hasUppercase: Bool {
        password.contains { $0.isUppercase }
    }

    var hasNumber: Bool {
        password.contains { $0.isNumber }
    }

    var hasSpecialCharacter: Bool {
        password.contains {
            !$0.isLetter && !$0.isNumber
        }
    }

    var completedRules: Int {
        [
            hasMinLength,
            hasUppercase,
            hasNumber,
            hasSpecialCharacter
        ]
        .filter { $0 }
        .count
    }

    var strengthProgress: Double {
        Double(completedRules) / 4.0
    }

    var strengthPercentage: Int {
        Int(strengthProgress * 100)
    }

    var passwordsMatch: Bool {
        !password.isEmpty &&
        password == confirmPassword
    }

    var canSubmit: Bool {
        completedRules == 4 &&
        passwordsMatch &&
        !isLoading
    }

    func changePassword() async {
        guard canSubmit else {
            return
        }

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanEmail.isEmpty else {
            presentError(
                "No se encontró el correo del usuario."
            )
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let success = try await useCase.execute(
                email: cleanEmail,
                newPassword: password
            )

            guard success else {
                presentError(
                    "No fue posible cambiar la contraseña."
                )
                return
            }

            showSuccess = true
        } catch {
            presentError(
                error.localizedDescription
            )
        }
    }

    func confirmSuccess() {
        showSuccess = false
        profileUseCase.logout()
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
