import Foundation
import Combine

@MainActor
final class CreateAccountViewModel: ObservableObject {

    // Inputs
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // UI
    @Published var isLoading: Bool = false

    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    // ✅ Navigation trigger
    @Published var goToOtp: Bool = false

    var canSubmit: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        passwordStrength.score >= 3 &&
        password == confirmPassword &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }

    var passwordStrength: PasswordStrength {
        PasswordStrength(password: password)
    }

    func onCreateAccount() {
        guard canSubmit else {
            presentAlert(title: "Revisa tus datos", message: "Completa el formulario y usa una contraseña segura.")
            return
        }

        isLoading = true
        Task {
            try? await Task.sleep(nanoseconds: 700_000_000)
            isLoading = false

            // ✅ aquí simulas que el backend mandó OTP
            goToOtp = true
        }
    }

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
