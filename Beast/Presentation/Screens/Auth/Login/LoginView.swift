import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel: LoginViewModel

    @State private var goToRecoverPassword: Bool = false
    @State private var goToCreateAccount: Bool = false

    init(viewModel: LoginViewModel = LoginViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BeastBackground")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {

                        GlassCard {
                            LoginHeaderView(
                                title: "SpinFlow",
                                subtitle: "¡Bienvenido de nuevo!",
                                description: "Ingresa tus credenciales para continuar tu entrenamiento."
                            )
                        }
                        .padding(.top, 28)

                        FeatureChipsRow(
                            items: [
                                .init(icon: "bicycle", title: "SPINNING"),
                                .init(icon: "bolt.fill", title: "POTENCIA"),
                                .init(icon: "heart.fill", title: "CARDIO"),
                                .init(icon: "timer", title: "TIEMPO")
                            ]
                        )
                        .padding(.top, 6)

                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Usuario")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(Color("BeastTextSecondary"))

                                BeastTextField(
                                    text: $viewModel.emailOrPhone,
                                    placeholder: "Correo electrónico o teléfono",
                                    systemImage: "envelope"
                                )

                                Text("Contraseña")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(Color("BeastTextSecondary"))
                                    .padding(.top, 2)

                                BeastSecureField(
                                    text: $viewModel.password,
                                    placeholder: "Ingresa tu contraseña",
                                    systemImage: "lock"
                                )

                                Button {
                                    goToRecoverPassword = true
                                } label: {
                                    Text("¿Olvidaste tu contraseña?")
                                        .font(.footnote.weight(.semibold))
                                        .foregroundStyle(Color("BeastYellowPrimary"))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.top, 2)
                            }
                        }
                        .padding(.top, 10)

                        PrimaryButton(
                            title: viewModel.isLoading ? "Cargando..." : "Iniciar Sesión",
                            isEnabled: viewModel.canSubmit && !viewModel.isLoading
                        ) {
                            viewModel.onLogin()
                        }
                        .padding(.top, 8)

                        DividerWithText(text: "¿NUEVO EN SPINFLOW?")
                            .padding(.top, 8)

                        SecondaryButton(title: "Crear una cuenta") {
                            // ✅ navegación a crear cuenta
                            goToCreateAccount = true
                        }

                        Text("Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad.")
                            .font(.caption2)
                            .foregroundStyle(Color("BeastTextSecondary"))
                            .multilineTextAlignment(.center)
                            .padding(.top, 6)
                            .padding(.bottom, 28)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToRecoverPassword) {
                RecoverPasswordView()
                    .navigationBarHidden(true)
            }
            .navigationDestination(isPresented: $goToCreateAccount) {
                CreateAccountView()
                    .navigationBarHidden(true)
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview("Login - Light") {
    LoginView()
        .preferredColorScheme(.light)
}

#Preview("Login - Dark") {
    LoginView()
        .preferredColorScheme(.dark)
}
