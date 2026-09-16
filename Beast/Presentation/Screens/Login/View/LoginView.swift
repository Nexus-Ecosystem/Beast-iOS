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

                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            LoginHeaderView()

                            loginForm
                                .padding(.top, 28)

                            Spacer(minLength: 24)

                            LoginLegalFooter()
                                .padding(.bottom, 30)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 42)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: proxy.size.height,
                            alignment: .topLeading
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            dismissKeyboard()
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .scrollBounceBehavior(.basedOnSize)
                }

                overlays
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .onChange(of: viewModel.loginSucceeded) { _, succeeded in
                guard succeeded else { return }

                viewModel.resetLoginSuccess()

                NotificationCenter.default.post(
                    name: .sessionDidChange,
                    object: nil
                )
            }
            .animation(
                .easeInOut(duration: 0.25),
                value: viewModel.errorMessage
            )
            .animation(
                .easeInOut(duration: 0.25),
                value: viewModel.isLoading
            )
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Form

    private var loginForm: some View {
        VStack(spacing: 0) {
            LoginTextField(
                title: "CORREO ELECTRÓNICO",
                placeholder: "nombre@ejemplo.com",
                text: $viewModel.email
            )
            .focused($focusedField, equals: .email)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()

            LoginPasswordField(
                title: "CONTRASEÑA",
                placeholder: "Contraseña",
                password: $viewModel.password,
                isVisible: $viewModel.isPasswordVisible
            )
            .focused($focusedField, equals: .password)
            .padding(.top, 16)

            forgotPasswordButton
                .padding(.top, 10)

            LoginButton(
                isEnabled: viewModel.isLoginEnabled,
                isLoading: viewModel.isLoading
            ) {
                dismissKeyboard()

                Task {
                    await viewModel.login()
                }
            }
            .padding(.top, 20)

            separator
                .padding(.vertical, 18)

            createAccountButton
        }
    }

    // MARK: - Forgot Password

    private var forgotPasswordButton: some View {
        Button {
            dismissKeyboard()
        } label: {
            Text("¿Olvidaste tu contraseña?")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(BeastColors.primary)
        }
        .buttonStyle(.plain)
        .frame(
            maxWidth: .infinity,
            alignment: .trailing
        )
    }

    // MARK: - Separator

    private var separator: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(BeastColors.border)
                .frame(height: 1)

            Text("Ó")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(BeastColors.textSecondary)

            Rectangle()
                .fill(BeastColors.border)
                .frame(height: 1)
        }
    }

    // MARK: - Create Account

    private var createAccountButton: some View {
        Button {
            dismissKeyboard()
            showSignUp = true
        } label: {
            Text("CREAR CUENTA")
                .font(.system(size: 12, weight: .bold))
                .tracking(1)
                .foregroundStyle(BeastColors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .overlay {
                    Capsule()
                        .stroke(
                            BeastColors.border,
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Overlays

    @ViewBuilder
    private var overlays: some View {
        if let error = viewModel.errorMessage {
            BeastAlertDialog(
                style: .error,
                title: "¡Aviso!",
                message: error.isEmpty
                    ? "Alguno de tus datos es incorrecto\nInténtalo de nuevo."
                    : error,
                buttonTitle: "Entendido"
            ) {
                viewModel.resetError()
                focusedField = nil
            }
            .transition(
                .opacity.combined(
                    with: .scale(scale: 0.96)
                )
            )
            .zIndex(10)
        }

        if viewModel.isLoading {
            BeastLoadingOverlay()
                .zIndex(20)
        }
    }

    // MARK: - Keyboard

    private func dismissKeyboard() {
        hideKeyboard()
        focusedField = nil
    }
}

#Preview {
    LoginView()
}
