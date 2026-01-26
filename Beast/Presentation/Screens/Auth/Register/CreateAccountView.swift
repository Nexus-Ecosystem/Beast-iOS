import SwiftUI

struct CreateAccountView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateAccountViewModel()

    // Header blur/tint
    @State private var scrollMinY: CGFloat = 0
    private let topBarHeight: CGFloat = 56

    var body: some View {
        ZStack(alignment: .top) {

            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {

                    // Sentinel offset
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .named("scroll")).minY
                            )
                    }
                    .frame(height: 1)

                    VStack(spacing: 6) {
                        Text("Empieza tu viaje")
                            .font(.title2.weight(.heavy))
                            .foregroundStyle(Color("BeastTextPrimary"))

                        Text("Únete a la comunidad de SpinFlow y lleva tu entrenamiento al siguiente nivel.")
                            .font(.subheadline)
                            .foregroundStyle(Color("BeastTextSecondary"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                    .padding(.top, 10)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {

                            Text("Nombre Completo")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color("BeastTextSecondary"))

                            BeastTextField(
                                text: $viewModel.fullName,
                                placeholder: "Ej. María Pérez",
                                systemImage: "person"
                            )

                            Text("Teléfono Móvil")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color("BeastTextSecondary"))
                                .padding(.top, 2)

                            BeastTextField(
                                text: $viewModel.phone,
                                placeholder: "+52 55 1234 5678",
                                systemImage: "phone"
                            )

                            HStack {
                                Text("Correo Electrónico")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundStyle(Color("BeastTextSecondary"))

                                Spacer()

                                Text("Opcional")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color("BeastSurface")))
                                    .overlay(Capsule().stroke(Color("BeastBorder"), lineWidth: 1))
                                    .foregroundStyle(Color("BeastTextSecondary"))
                            }
                            .padding(.top, 2)

                            BeastTextField(
                                text: $viewModel.email,
                                placeholder: "nombre@ejemplo.com",
                                systemImage: "envelope"
                            )

                            Text("Contraseña")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color("BeastTextSecondary"))
                                .padding(.top, 2)

                            BeastSecureField(
                                text: $viewModel.password,
                                placeholder: "••••••••",
                                systemImage: "lock"
                            )

                            PasswordStrengthCard(strength: viewModel.passwordStrength)
                                .padding(.top, 4)

                            Text("Confirmar Contraseña")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color("BeastTextSecondary"))
                                .padding(.top, 2)

                            BeastSecureField(
                                text: $viewModel.confirmPassword,
                                placeholder: "••••••••",
                                systemImage: "checkmark.shield"
                            )
                        }
                    }
                    .padding(.top, 8)

                    PrimaryButton(
                        title: viewModel.isLoading ? "Creando..." : "Crear Cuenta",
                        isEnabled: viewModel.canSubmit && !viewModel.isLoading
                    ) {
                        viewModel.onCreateAccount()
                    }
                    .padding(.top, 6)

                    HStack(spacing: 6) {
                        Text("¿Ya tienes cuenta?")
                            .font(.footnote)
                            .foregroundStyle(Color("BeastTextSecondary"))

                        Button {
                            dismiss()
                        } label: {
                            Text("Inicia Sesión")
                                .font(.footnote.weight(.bold))
                                .foregroundStyle(Color("BeastYellowPrimary"))
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 28)
                }
                .padding(.horizontal, 20)
                .padding(.top, topBarHeight + 10)
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { minY in
                scrollMinY = minY
            }

            let scrolled = max(0, -scrollMinY)
            let progress = min(scrolled / 24, 1)

            GlassTopBar(title: "Crear Cuenta", progress: progress) {
                dismiss()
            }
            .zIndex(10)
        }
        .navigationBarHidden(true)

        // ✅ Navigation to OTP (sin callbacks raros)
        .navigationDestination(isPresented: $viewModel.goToOtp) {
            OtpVerificationView(emailMasked: maskedEmail(viewModel.email))
                .navigationBarHidden(true)
        }

        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private func maskedEmail(_ email: String) -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "usuario@ejemplo.com" : trimmed
    }
}

#Preview("Create Account - Light") {
    NavigationStack { CreateAccountView() }
        .preferredColorScheme(.light)
}
