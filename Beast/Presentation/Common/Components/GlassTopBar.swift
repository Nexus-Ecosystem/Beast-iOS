import SwiftUI

struct GlassTopBar: View {
    let title: String
    let progress: CGFloat          // 0...1
    let onBack: () -> Void

    var body: some View {
        ZStack {
            // ✅ Blur base (siempre)
            BlurView(style: .systemUltraThinMaterial)
                .opacity(0.85)
                .ignoresSafeArea(edges: .top)

            // ✅ Tint que sube con el scroll para sentirse más “sólido”
            Color("BeastBackground")
                .opacity(0.08 + 0.45 * progress)   // 0.10 → 0.65
                .ignoresSafeArea(edges: .top)

            // línea inferior aparece con el scroll
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color("BeastBorder"))
                    .frame(height: 0.8)
                    .opacity(0.05 + 0.35 * progress)
            }
            .ignoresSafeArea(edges: .top)

            HStack(spacing: 12) {
                IconButtonBack(action: onBack)

                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color("BeastTextPrimary"))

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 6)
            .padding(.bottom, 10)
        }
        .frame(height: 56)
    }
}
