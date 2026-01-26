import SwiftUI

struct RecoverPasswordView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RecoverPasswordViewModel()

    @State private var scrollMinY: CGFloat = 0

    private let topBarHeight: CGFloat = 56

    var body: some View {
        ZStack(alignment: .top) {

            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {

                    // ✅ Sentinel para offset
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .named("scroll")).minY
                            )
                    }
                    .frame(height: 1)

                    RecoverIconHeader()
                        .padding(.top, 18)

                    VStack(spacing: 8) {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.title3.weight(.heavy))
                            .foregroundStyle(Color("BeastTextPrimary"))
                            .multilineTextAlignment(.center)

                        Text("No te preocupes. Ingresa tus datos asociados para restablecerla.")
                            .font(.subheadline)
                            .foregroundStyle(Color("BeastTextSecondary"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Correo electrónico o teléfono")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Color("BeastTextSecondary"))

                            BeastTextField(
                                text: $viewModel.emailOrPhone,
                                placeholder: "ej. usuario@spinflow.com",
                                systemImage: "envelope"
                            )

                            Text("Te enviaremos un código de 6 dígitos para verificar tu identidad.")
                                .font(.caption)
                                .foregroundStyle(Color("BeastTextSecondary"))
                                .padding(.top, 2)

                            PrimaryButton(
                                title: viewModel.isLoading ? "Enviando..." : "Enviar Código",
                                isEnabled: viewModel.canSubmit && !viewModel.isLoading
                            ) {
                                viewModel.onSendCode()
                            }
                            .padding(.top, 6)
                        }
                    }

                    DividerWithText(text: "O INTENTA")
                        .padding(.top, 4)

                    SecondaryButton(title: "Volver a Iniciar Sesión") {
                        dismiss()
                    }

                    GlassCard {
                        SupportCard(onTap: {
                            viewModel.onContactSupport()
                        })
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .padding(.top, topBarHeight + 10)
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { minY in
                scrollMinY = minY
            }

            // ✅ Progress agresivo: 0→1 en 24px
            let scrolled = max(0, -scrollMinY)
            let progress = min(scrolled / 24, 1)

            GlassTopBar(title: "Recuperación", progress: progress) {
                dismiss()
            }
            .zIndex(10)
        }
        .navigationBarHidden(true)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
