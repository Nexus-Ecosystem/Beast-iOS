import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {
    @Published var isAuthenticated: Bool

    init(
        isAuthenticated: Bool = AppStorageManager.shared.isLoggedIn
    ) {
        self.isAuthenticated = isAuthenticated
    }

    func loginCompleted() {
        isAuthenticated = true
    }

    func logout() {
        AppStorageManager.shared.clearSession()
        isAuthenticated = false
    }
}
