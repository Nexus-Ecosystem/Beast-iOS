import SwiftUI

struct BeastLoadingOverlay: View {
    var message: String? = nil

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.62)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                BeastLottieView(
                    animationName: "loader"
                )
                .frame(width: 110, height: 110)

                if let message {
                    Text(message)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.78))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    BeastLoadingOverlay(
        message: "Iniciando sesión..."
    )
}
