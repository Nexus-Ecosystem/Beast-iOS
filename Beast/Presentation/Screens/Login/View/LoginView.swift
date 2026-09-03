import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var router: AppRouter
    @FocusState private var focusedField: Field?

    enum Field {
        case email
        case password
    }

    var body: some View {
        ZStack {
            background

            VStack(alignment: .leading, spacing: 0) {
                LoginHeaderView()

                Spacer()
                    .frame(height: 30)

                LoginTextField(
                    title: "CORREO ELECTRÓNICO",
                    placeholder: "nombre@ejemplo.com",
                    text: $viewModel.email
                )
                .focused($focusedField, equals: .email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()

                Spacer()
                    .frame(height: 14)

                LoginPasswordField(
                    title: "CONTRASEÑA",
                    placeholder: "Contraseña",
                    password: $viewModel.password,
                    isVisible: $viewModel.isPasswordVisible
                )
                .focused($focusedField, equals: .password)

                Button {
                    hideKeyboard()
                    focusedField = nil
                } label: {
                    Text("¿Olvidaste tu contraseña?")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(BeastColors.primary)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)

                Spacer()
                    .frame(height: 18)

                LoginButton(
                    isEnabled: viewModel.isLoginEnabled,
                    isLoading: viewModel.isLoading
                ) {
                    hideKeyboard()
                    focusedField = nil

                    Task {
                        await viewModel.login()
                    }
                }

                Spacer()
                    .frame(height: 14)

                HStack(spacing: 10) {
                    Rectangle()
                        .fill(Color.black.opacity(0.15))
                        .frame(height: 1)

                    Text("Ó")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.45))

                    Rectangle()
                        .fill(Color.black.opacity(0.15))
                        .frame(height: 1)
                }

                Spacer()
                    .frame(height: 14)

                Button {
                } label: {
                    Text("CREAR CUENTA")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(1)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay {
                            Capsule()
                                .stroke(
                                    Color.black.opacity(0.20),
                                    lineWidth: 1
                                )
                        }
                }
                .buttonStyle(.plain)

                Spacer()

                LoginLegalFooter()
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 30)
            .padding(.top, 58)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
                focusedField = nil
            }

            if let error = viewModel.errorMessage {
                BeastAlertDialog(
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
        .onChange(of: viewModel.loginSucceeded) { _, succeeded in
            guard succeeded else { return }

            viewModel.resetLoginSuccess()
            router.loginCompleted()
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var background: some View {
        ZStack {
            Image("login_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.white.opacity(0.88),
                    Color.white.opacity(0.93),
                    Color.white.opacity(0.97)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppRouter())
}
