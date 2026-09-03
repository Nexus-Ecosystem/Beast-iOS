import Foundation
import Combine
import UIKit

@MainActor
final class QrCheckInViewModel: ObservableObject {
    @Published private(set) var profile: AllDataProfileUserSystem?
    @Published private(set) var qrImage: UIImage?
    @Published private(set) var timeLeft: Int = 105
    @Published var errorMessage: String?

    private let storage: AppStorageManager
    private let refreshInterval = 105

    init(
        storage: AppStorageManager = .shared
    ) {
        self.storage = storage
    }

    var nip: String {
        profile?.nipSocio ?? ""
    }

    var formattedTime: String {
        let minutes = timeLeft / 60
        let seconds = timeLeft % 60

        return String(
            format: "%02d:%02d",
            minutes,
            seconds
        )
    }

    func load() {
        guard let profile = storage.getProfile() else {
            errorMessage = "No se encontró la información del usuario."
            return
        }

        self.profile = profile

        generateQRCode()
    }

    func startTimer() async {
        timeLeft = refreshInterval

        while !Task.isCancelled {
            do {
                try await Task.sleep(
                    for: .seconds(1)
                )
            } catch {
                return
            }

            guard !Task.isCancelled else {
                return
            }

            if timeLeft > 1 {
                timeLeft -= 1
            } else {
                refreshQRCode()
            }
        }
    }

    func resetError() {
        errorMessage = nil
    }

    private func refreshQRCode() {
        generateQRCode()
        timeLeft = refreshInterval
    }

    private func generateQRCode() {
        guard let profile else {
            return
        }

        let qrDataString = [
            profile.nipSocio,
            profile.idSocio,
            profile.email,
            profile.phone
        ]
        .joined(separator: "/")

        guard let encryptedData = CryptoManager.encrypt(
            qrDataString
        ) else {
            errorMessage = "No fue posible generar el código QR."
            return
        }

        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🔐 QR CHECK-IN")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("Encrypted payload: \(encryptedData)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif

        qrImage = QRCodeGenerator.generate(
            from: encryptedData
        )
    }
}
