import SwiftUI

struct OtpVerificationView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: OtpVerificationViewModel

    // Header scroll (igual que las otras)
    @State private var scrollMinY: CGFloat = 0
    private let topBarHeight: CGFloat = 56

    init(emailMasked: String = "usuario@ejemplo.com") {
        _viewModel = StateObject(wrappedValue: OtpVerificationViewModel(emailMasked: emailMasked))
    }

    var body: some View {
        ZStack(alignment: .top) {

            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {

                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .named("scroll")).minY
                            )
                    }
                    .frame(height: 1)

                    // Icon
                    Circle()
                        .fill(Color("BeastSurface"))
                        .frame(width: 64, height: 64)
                        .overlay(Circle().stroke(Color("BeastBorder"), lineWidth: 1))
                        .overlay(
                            Image(systemName: "lock.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color("BeastYellowPrimary"))
                        )
                        .padding(.top, 14)

                    VStack(spacing: 8) {
                        Text("Ingresa el código")
                            .font(.title3.weight(.heavy))
                            .foregroundStyle(Color("BeastTextPrimary"))

                        Text("Hemos enviado un código de 4 dígitos a\n\(viewModel.emailMasked)")
                            .font(.subheadline)
                            .foregroundStyle(Color("BeastTextSecondary"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }

                    OtpCodeInputView(
                        d1: $viewModel.d1,
                        d2: $viewModel.d2,
                        d3: $viewModel.d3,
                        d4: $viewModel.d4
                    )
                    .padding(.top, 4)

                    PrimaryButton(
                        title: viewModel.isLoading ? "Verificando..." : "Verificar código",
                        isEnabled: viewModel.canVerify && !viewModel.isLoading
                    ) {
                        viewModel.onVerify()
                    }
                    .padding(.top, 8)

                    VStack(spacing: 6) {
                        Text("¿No recibiste el código?")
                            .font(.footnote)
                            .foregroundStyle(Color("BeastTextSecondary"))

                        if viewModel.isResendEnabled {
                            Button {
                                viewModel.onResend()
                            } label: {
                                Text("Reenviar código")
                                    .font(.footnote.weight(.bold))
                                    .foregroundStyle(Color("BeastYellowPrimary"))
                            }
                        } else {
                            Text("Reenviar en 00:\(String(format: "%02d", viewModel.secondsLeft))")
                                .font(.caption)
                                .foregroundStyle(Color("BeastTextSecondary"))
                        }
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, topBarHeight + 10)
                .padding(.bottom, 28)
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { minY in
                scrollMinY = minY
            }

            let scrolled = max(0, -scrollMinY)
            let progress = min(scrolled / 24, 1)

            GlassTopBar(title: "Verificación", progress: progress) {
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

#Preview("OTP - Light") {
    NavigationStack { OtpVerificationView(emailMasked: "usuario@ejemplo.com") }
        .preferredColorScheme(.light)
}
