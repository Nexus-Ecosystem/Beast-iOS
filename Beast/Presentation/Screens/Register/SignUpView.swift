import SwiftUI

struct SignUpView: View {
    @StateObject
    private var viewModel =
        SignUpViewModel()

    @Environment(\.dismiss)
    private var dismiss

    @State
    private var userForVerification:
        RegistrationUser?

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
                    header

                    SignUpTextField(
                        title:
                            "NOMBRE COMPLETO",
                        placeholder:
                            "Ej. Alex Rivera",
                        text:
                            $viewModel.fullName
                    )
                    .padding(.top, 28)

                    SignUpTextField(
                        title:
                            "TELÉFONO MÓVIL",
                        placeholder:
                            "+52 33 0000 0000",
                        text:
                            $viewModel.phone,
                        keyboardType:
                            .phonePad
                    )
                    .padding(.top, 16)

                    SignUpTextField(
                        title:
                            "CORREO ELECTRÓNICO",
                        placeholder:
                            "nombre@ejemplo.com",
                        text:
                            $viewModel.email,
                        keyboardType:
                            .emailAddress
                    )
                    .padding(.top, 16)

                    SignUpPasswordField(
                        title:
                            "CONTRASEÑA",
                        password:
                            $viewModel.password,
                        isVisible:
                            $viewModel.passwordVisible
                    )
                    .padding(.top, 16)

                    SignUpPasswordField(
                        title:
                            "CONFIRMAR CONTRASEÑA",
                        password:
                            $viewModel.confirmPassword,
                        isVisible:
                            $viewModel.confirmPasswordVisible
                    )
                    .padding(.top, 16)

                    if !viewModel
                        .confirmPassword
                        .isEmpty &&
                        !viewModel.passwordsMatch
                    {
                        Text(
                            "Las contraseñas no coinciden"
                        )
                        .font(
                            .system(
                                size: 10,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            BeastColors.danger
                        )
                        .padding(
                            .leading,
                            12
                        )
                        .padding(
                            .top,
                            8
                        )
                    }

                    SignUpPasswordSecurityCard(
                        score:
                            viewModel.securityScore,
                        hasUppercase:
                            viewModel.hasUppercase,
                        hasNumber:
                            viewModel.hasNumber,
                        hasSpecialCharacter:
                            viewModel.hasSpecialCharacter,
                        hasMinLength:
                            viewModel.hasMinLength
                    )
                    .padding(
                        .top,
                        20
                    )

                    createButton
                        .padding(
                            .top,
                            30
                        )

                    loginFooter
                        .padding(
                            .top,
                            22
                        )

                    Spacer()
                        .frame(
                            height: 30
                        )
                }
                .padding(
                    .horizontal,
                    24
                )
                .padding(
                    .top,
                    20
                )
            }

            if viewModel.isLoading {
                BeastLoadingOverlay()
                    .zIndex(20)
            }

            if viewModel.showError {
                BeastAlertDialog(
                    title:
                        "¡Aviso!",
                    message:
                        viewModel.errorMessage,
                    buttonTitle:
                        "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(30)
            }
        }
        .navigationDestination(
            item:
                $userForVerification
        ) { user in
            VerificationView(
                user: user,
                mode: .registration
            )
        }
        .navigationTitle(
            "Crear cuenta"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar(
            .hidden,
            for: .tabBar
        )
    }

    private var header:
        some View
    {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            HStack(
                spacing: 7
            ) {
                Text(
                    "EMPIEZA TU"
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )

                Text(
                    "VIAJE"
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }
            .font(
                .system(
                    size: 31,
                    weight: .black
                )
            )
            .italic()

            Text(
                "Únete a la comunidad de Beast y lleva tu entrenamiento al siguiente nivel."
            )
            .font(
                .system(
                    size: 14,
                    weight: .regular
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
        }
    }

    private var createButton:
        some View
    {
        Button {
            Task {
                let success =
                    await viewModel.sendOtp()

                guard success else {
                    return
                }

                userForVerification =
                    viewModel.user
            }
        } label: {
            HStack(
                spacing: 8
            ) {
                Text(
                    "CREAR CUENTA"
                )
                .font(
                    .system(
                        size: 13,
                        weight: .black
                    )
                )

                Image(
                    systemName:
                        "arrow.right"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold
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
                height: 56
            )
            .background(
                Capsule()
                    .fill(
                        BeastColors.primary.opacity(
                            viewModel.isFormValid
                                ? 1
                                : 0.3
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(
            !viewModel.isFormValid
        )
    }

    private var loginFooter:
        some View
    {
        HStack(
            spacing: 4
        ) {
            Text(
                "¿Ya tienes cuenta?"
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )

            Button(
                "Inicia Sesión"
            ) {
                dismiss()
            }
            .foregroundStyle(
                BeastColors.primary
            )
            .fontWeight(
                .bold
            )
        }
        .font(
            .system(
                size: 12,
                weight: .semibold
            )
        )
        .frame(
            maxWidth: .infinity
        )
    }
}
