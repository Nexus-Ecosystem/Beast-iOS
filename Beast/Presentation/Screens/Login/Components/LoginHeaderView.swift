import SwiftUI

struct LoginHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("beast_logo_black")
                .resizable()
                .scaledToFit()
                .frame(width: 125)
                .padding(.bottom, 24)

            Text("Un paso a tu Bienestar")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(BeastColors.primary)
                .padding(.bottom, 8)

            Text("BIENVENIDO\nDE NUEVO")
                .font(.system(size: 42, weight: .black))
                .italic()
                .foregroundStyle(.black)
                .lineSpacing(-3)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
