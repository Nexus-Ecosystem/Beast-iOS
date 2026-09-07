import SwiftUI

struct ChangePasswordView: View {
    @StateObject
    private var viewModel: ChangePasswordViewModel

    @State
    private var passwordVisible = false

    @State
    private var confirmPasswordVisible = false

    init(
        email: String
    ) {
        _viewModel = StateObject(
            wrappedValue: ChangePasswordViewModel(
                email: email
            )
        )
    }

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 0
                ) {
                    Text(
                        "DEFINE TU NUEVA\nIDENTIDAD DIGITAL."
                    )
                    .font(
                        .system(
                            size: 29,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
                    .padding(
                        .top,
                        12
                    )

                    BeastPasswordField(
                        title: "NUEVA CONTRASEÑA",
                        text: $viewModel.password,
                        isVisible: $passwordVisible
                    )
                    .padding(
                        .top,
                        30
                    )

                    PasswordStrengthCard(
                        progress: viewModel.strengthProgress,
                        percentage: viewModel.strengthPercentage,
                        hasUppercase: viewModel.hasUppercase,
                        hasNumber: viewModel.hasNumber,
                        hasSpecialCharacter: viewModel.hasSpecialCharacter,
                        hasMinLength: viewModel.hasMinLength
                    )
                    .padding(
                        .top,
                        24
                    )

                    BeastPasswordField(
                        title: "CONFIRMAR CONTRASEÑA",
                        text: $viewModel.confirmPassword,
                        isVisible: $confirmPasswordVisible
                    )
                    .padding(
                        .top,
                        30
                    )

                    Spacer()
                        .frame(
                            minHeight: 80
                        )

                    changePasswordButton
                }
                .padding(
                    .horizontal,
                    24
                )
                .padding(
                    .bottom,
                    24
                )
            }

            if viewModel.isLoading {
                BeastLoadingOverlay()
            }
        }
        .navigationTitle(
            "Cambia tu contraseña"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbarBackground(
            BeastColors.background,
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .alert(
            "¡Felicidades!",
            isPresented: $viewModel.showSuccess
        ) {
            Button(
                "Entendido"
            ) {
                viewModel.confirmSuccess()
            }
        } message: {
            Text(
                "Cambiaste tu contraseña correctamente. Ahora puedes ingresar con tu nueva contraseña."
            )
        }
        .alert(
            "No fue posible continuar",
            isPresented: $viewModel.showError
        ) {
            Button(
                "Entendido"
            ) {
                viewModel.closeError()
            }
        } message: {
            Text(
                viewModel.errorMessage
            )
        }
    }

    private var changePasswordButton: some View {
        Button {
            Task {
                await viewModel.changePassword()
            }
        } label: {
            HStack(
                spacing: 8
            ) {
                Text(
                    "CAMBIAR CONTRASEÑA"
                )
                .font(
                    .system(
                        size: 12,
                        weight: .black
                    )
                )

                Image(
                    systemName: "bolt.fill"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .black
                    )
                )
            }
            .foregroundStyle(
                BeastColors.buttonText
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: 58
            )
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
        .buttonStyle(
            .plain
        )
        .disabled(
            !viewModel.canSubmit
        )
    }
}
