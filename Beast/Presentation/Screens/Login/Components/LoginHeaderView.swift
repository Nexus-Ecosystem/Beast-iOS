import SwiftUI

struct LoginHeaderView: View {
    @Environment(\.colorScheme)
    private var colorScheme

    private var logoName: String {
        colorScheme == .dark
            ? "beast_logo_white"
            : "beast_logo_black"
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            Image(logoName)
                .resizable()
                .scaledToFit()
                .frame(width: 125)
                .padding(.bottom, 24)

            Text("Un paso a tu Bienestar")
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
                .padding(.bottom, 8)

            Text("BIENVENIDO\nDE NUEVO")
                .font(
                    .system(
                        size: 42,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .lineSpacing(-3)
                .minimumScaleFactor(0.85)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}
