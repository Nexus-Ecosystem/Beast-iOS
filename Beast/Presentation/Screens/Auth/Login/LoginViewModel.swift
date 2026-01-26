import Foundation
import Combine

final class LoginViewModel: ObservableObject {

    @Published var emailOrPhone: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false

    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    var canSubmit: Bool {
        !emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @MainActor
    func onLogin() {
        guard canSubmit else {
            presentAlert(title: "Faltan datos", message: "Completa usuario y contraseña.")
            return
        }

        isLoading = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            isLoading = false
            presentAlert(title: "Login", message: "Listo: aquí irá el servicio real.")
        }
    }

    @MainActor
    func onForgotPassword() {
        presentAlert(title: "Recuperar", message: "Aquí irá el flujo de recuperación.")
    }

    @MainActor
    func onCreateAccount() {
        presentAlert(title: "Registro", message: "Aquí irá el flujo de creación de cuenta.")
    }

    @MainActor
    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
