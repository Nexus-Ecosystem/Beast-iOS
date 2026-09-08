import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?

    @State private var showSignUp = false

    enum Field {
        case email
        case password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LoginBackgroundView()

                ScrollView(
                    showsIndicators: false
                ) {
                    VStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        LoginHeaderView()

                        Spacer()
                            .frame(height: 30)

                        LoginTextField(
                            title: "CORREO ELECTRÓNICO",
                            placeholder: "nombre@ejemplo.com",
                            text: $viewModel.email
                        )
                        .focused(
                            $focusedField,
                            equals: .email
                        )
                        .textInputAutocapitalization(
                            .never
                        )
                        .keyboardType(
                            .emailAddress
                        )
                        .autocorrectionDisabled()

                        Spacer()
                            .frame(height: 14)

                        LoginPasswordField(
                            title: "CONTRASEÑA",
                            placeholder: "Contraseña",
                            password: $viewModel.password,
                            isVisible: $viewModel.isPasswordVisible
                        )
                        .focused(
                            $focusedField,
                            equals: .password
                        )

                        Button {
                            hideKeyboard()
                            focusedField = nil
                        } label: {
                            Text(
                                "¿Olvidaste tu contraseña?"
                            )
                            .font(
                                .system(
                                    size: 10,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(
                                BeastColors.primary
                            )
                        }
                        .buttonStyle(.plain)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .trailing
                        )
                        .padding(
                            .top,
                            10
                        )

                        Spacer()
                            .frame(height: 18)

                        LoginButton(
                            isEnabled:
                                viewModel.isLoginEnabled,
                            isLoading:
                                viewModel.isLoading
                        ) {
                            hideKeyboard()
                            focusedField = nil

                            Task {
                                await viewModel.login()
                            }
                        }

                        Spacer()
                            .frame(height: 14)

                        HStack(
                            spacing: 10
                        ) {
                            Rectangle()
                                .fill(
                                    BeastColors.border
                                )
                                .frame(
                                    height: 1
                                )

                            Text("Ó")
                                .font(
                                    .system(
                                        size: 9,
                                        weight: .medium
                                    )
                                )
                                .foregroundStyle(
                                    BeastColors.textSecondary
                                )

                            Rectangle()
                                .fill(
                                    BeastColors.border
                                )
                                .frame(
                                    height: 1
                                )
                        }

                        Spacer()
                            .frame(height: 14)

                        Button {
                            hideKeyboard()
                            focusedField = nil
                            showSignUp = true
                        } label: {
                            Text(
                                "CREAR CUENTA"
                            )
                            .font(
                                .system(
                                    size: 12,
                                    weight: .bold
                                )
                            )
                            .tracking(1)
                            .foregroundStyle(
                                BeastColors.textPrimary
                            )
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(
                                height: 48
                            )
                            .overlay {
                                Capsule()
                                    .stroke(
                                        BeastColors.border,
                                        lineWidth: 1
                                    )
                            }
                        }
                        .buttonStyle(.plain)

                        Spacer()
                            .frame(
                                minHeight: 260
                            )

                        LoginLegalFooter()
                            .padding(
                                .bottom,
                                8
                            )
                    }
                    .padding(
                        .horizontal,
                        30
                    )
                    .padding(
                        .top,
                        58
                    )
                    .padding(
                        .bottom,
                        24
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
                    .contentShape(
                        Rectangle()
                    )
                    .onTapGesture {
                        hideKeyboard()
                        focusedField = nil
                    }
                }
                .scrollDismissesKeyboard(
                    .interactively
                )

                if let error =
                    viewModel.errorMessage
                {
                    BeastAlertDialog(
                        style: .error,
                        title: "¡Aviso!",
                        message:
                            error.isEmpty
                            ? "Alguno de tus datos es incorrecto\nInténtalo de nuevo."
                            : error,
                        buttonTitle:
                            "Entendido"
                    ) {
                        viewModel.resetError()
                        focusedField = nil
                    }
                    .transition(
                        .opacity.combined(
                            with:
                                .scale(
                                    scale: 0.96
                                )
                        )
                    )
                    .zIndex(10)
                }

                if viewModel.isLoading {
                    BeastLoadingOverlay()
                        .zIndex(20)
                }
            }
            .navigationDestination(
                isPresented:
                    $showSignUp
            ) {
                SignUpView()
            }
            .onChange(
                of:
                    viewModel.loginSucceeded
            ) { _, succeeded in
                guard succeeded else {
                    return
                }

                viewModel
                    .resetLoginSuccess()

                NotificationCenter
                    .default
                    .post(
                        name:
                            .sessionDidChange,
                        object:
                            nil
                    )
            }
            .animation(
                .easeInOut(
                    duration: 0.25
                ),
                value:
                    viewModel.errorMessage
            )
            .animation(
                .easeInOut(
                    duration: 0.25
                ),
                value:
                    viewModel.isLoading
            )
            .navigationBarBackButtonHidden(
                true
            )
        }
    }
}

#Preview {
    LoginView()
}
