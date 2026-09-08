import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var loginSucceeded: Bool = false

    private let loginUserUseCase: LoginUserUseCase
    private let storage: AppStorageManager

    init(
        loginUserUseCase: LoginUserUseCase = LoginUserUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.loginUserUseCase = loginUserUseCase
        self.storage = storage
    }

    var isLoginEnabled: Bool {
        !email
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty &&
        !password.isEmpty &&
        !isLoading
    }

    func login() async {
        guard isLoginEnabled else {
            return
        }

        isLoading = true
        errorMessage = nil
        loginSucceeded = false

        defer {
            isLoading = false
        }

        do {
            let cleanEmail = email
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

            let response = try await loginUserUseCase.execute(
                email: cleanEmail,
                password: password,
                tokenFirebase: ""
            )

            let profile = response.toDomain()

            storage.saveLoginSession(
                profile
            )

            loginSucceeded = true
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage =
                "Ocurrió un error al iniciar sesión."
        }
    }

    func resetError() {
        errorMessage = nil
    }

    func resetLoginSuccess() {
        loginSucceeded = false
    }

    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
}
