import Foundation
import Combine

@MainActor
final class RecoverPasswordViewModel: ObservableObject {

    @Published var emailOrPhone: String = ""
    @Published var isLoading: Bool = false

    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    var canSubmit: Bool {
        !emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func onSendCode() {
        guard canSubmit else {
            presentAlert(title: "Faltan datos", message: "Ingresa tu correo o teléfono.")
            return
        }

        isLoading = true
        Task {
            try? await Task.sleep(nanoseconds: 700_000_000)
            isLoading = false
            presentAlert(title: "Código enviado", message: "Aquí irá el envío real por servicio.")
        }
    }

    func onBackToLogin() {
        // navegación desde la view
    }

    func onContactSupport() {
        presentAlert(title: "Soporte", message: "Aquí abrimos soporte (correo/whatsapp/web).")
    }

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
