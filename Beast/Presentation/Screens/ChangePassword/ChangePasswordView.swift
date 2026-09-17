import SwiftUI

struct ChangePasswordView: View {
    @StateObject private var viewModel: ChangePasswordViewModel

    @State private var passwordVisible = false
    @State private var confirmPasswordVisible = false

    let onCompleted: () -> Void

    init(
        email: String,
        onCompleted: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(
            wrappedValue: ChangePasswordViewModel(
                email: email
            )
        )

        self.onCompleted = onCompleted
    }

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("DEFINE TU NUEVA\nIDENTIDAD DIGITAL.")
                        .font(.system(size: 29, weight: .black))
                        .italic()
                        .foregroundStyle(BeastColors.textPrimary)
                        .padding(.top, 18)

                    BeastPasswordField(
                        title: "NUEVA CONTRASEÑA",
                        text: $viewModel.password,
                        isVisible: $passwordVisible
                    )
                    .padding(.top, 30)

                    PasswordStrengthCard(
                        progress: viewModel.strengthProgress,
                        percentage: viewModel.strengthPercentage,
                        hasUppercase: viewModel.hasUppercase,
                        hasNumber: viewModel.hasNumber,
                        hasSpecialCharacter:
                            viewModel.hasSpecialCharacter,
                        hasMinLength: viewModel.hasMinLength
                    )
                    .padding(.top, 24)

                    BeastPasswordField(
                        title: "CONFIRMAR CONTRASEÑA",
                        text: $viewModel.confirmPassword,
                        isVisible: $confirmPasswordVisible
                    )
                    .padding(.top, 30)

                    passwordMismatchMessage

                    Spacer()
                        .frame(minHeight: 80)

                    changePasswordButton
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)

            overlays
        }
        .navigationTitle("Cambia tu contraseña")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: - Validation

    @ViewBuilder
    private var passwordMismatchMessage: some View {
        if !viewModel.confirmPassword.isEmpty &&
            viewModel.password != viewModel.confirmPassword {
            HStack(spacing: 6) {
                Image(
                    systemName:
                        "exclamationmark.circle.fill"
                )

                Text(
                    "Las contraseñas no coinciden."
                )
            }
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.red)
            .padding(.top, 10)
        }
    }

    // MARK: - Button

    private var changePasswordButton: some View {
        Button {
            hideKeyboard()

            Task {
                await viewModel.changePassword()
            }
        } label: {
            HStack(spacing: 8) {
                Text("CAMBIAR CONTRASEÑA")
                    .font(.system(size: 12, weight: .black))

                Image(systemName: "bolt.fill")
                    .font(.system(size: 14, weight: .black))
            }
            .foregroundStyle(BeastColors.buttonText)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                Capsule()
                    .fill(
                        BeastColors.primary.opacity(
                            viewModel.canSubmit
                                ? 1
                                : 0.45
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(
            !viewModel.canSubmit ||
            viewModel.isLoading
        )
    }

    // MARK: - Overlays

    @ViewBuilder
    private var overlays: some View {
        if viewModel.isLoading {
            BeastLoadingOverlay()
                .zIndex(100)
        }

        if viewModel.showError {
            BeastAlertDialog(
                style: .error,
                title: "¡Aviso!",
                message: viewModel.errorMessage,
                buttonTitle: "Entendido"
            ) {
                viewModel.closeError()
            }
            .zIndex(200)
        }

        if viewModel.showSuccess {
            BeastAlertDialog(
                style: .success,
                title: "¡Felicidades!",
                message: "Cambiaste tu contraseña correctamente. Ahora puedes ingresar con tu nueva contraseña.",
                buttonTitle: "Entendido"
            ) {
                viewModel.confirmSuccess()
                onCompleted()
            }
            .zIndex(300)
        }
    }
}
