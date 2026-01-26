import Foundation
import Combine

@MainActor
final class OtpVerificationViewModel: ObservableObject {

    let emailMasked: String

    @Published var d1: String = ""
    @Published var d2: String = ""
    @Published var d3: String = ""
    @Published var d4: String = ""

    @Published var secondsLeft: Int = 30
    @Published var isResendEnabled: Bool = false
    @Published var isLoading: Bool = false

    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    private var timer: Timer?

    init(emailMasked: String = "usuario@ejemplo.com") {
        self.emailMasked = emailMasked
        startTimer()
    }

    var code: String { d1 + d2 + d3 + d4 }

    var canVerify: Bool {
        code.count == 4 && !code.contains(where: { $0 == " " })
    }

    func startTimer() {
        timer?.invalidate()
        secondsLeft = 30
        isResendEnabled = false

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                if self.secondsLeft > 0 {
                    self.secondsLeft -= 1
                } else {
                    self.isResendEnabled = true
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }

    func onResend() {
        guard isResendEnabled else { return }
        startTimer()
        presentAlert(title: "Código reenviado", message: "Te enviamos un nuevo código.")
    }

    func onVerify() {
        guard canVerify else { return }
        isLoading = true

        Task {
            try? await Task.sleep(nanoseconds: 650_000_000)
            isLoading = false
            presentAlert(title: "Listo", message: "OTP verificado (aquí irá el flujo real con servicios).")
        }
    }

    func clearAll() {
        d1 = ""; d2 = ""; d3 = ""; d4 = ""
    }

    private func presentAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    deinit {
        timer?.invalidate()
    }
}
