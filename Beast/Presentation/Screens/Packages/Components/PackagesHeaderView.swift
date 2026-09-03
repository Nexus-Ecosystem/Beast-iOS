import SwiftUI

struct PackagesHeaderView: View {

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            headerBackground

            HStack {
                Text("Membresías y Paquetes")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .italic()
                    .foregroundStyle(BeastPackageColors.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
        }
        .frame(height: 112)
        .ignoresSafeArea(edges: .top)
    }

    private var headerBackground: some View {
        ZStack {

            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0.00),
                            .init(color: .black, location: 0.18),
                            .init(color: .black.opacity(0.75), location: 0.45),
                            .init(color: .black.opacity(0.35), location: 0.72),
                            .init(color: .clear, location: 1.00)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            LinearGradient(
                stops: [
                    .init(color: headerAccent.opacity(0.22), location: 0.00),
                    .init(color: headerAccent.opacity(0.14), location: 0.20),
                    .init(color: headerAccent.opacity(0.08), location: 0.45),
                    .init(color: headerAccent.opacity(0.03), location: 0.70),
                    .init(color: .clear, location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            LinearGradient(
                stops: [
                    .init(color: BeastPackageColors.background.opacity(0.98), location: 0.00),
                    .init(color: BeastPackageColors.background.opacity(0.86), location: 0.26),
                    .init(color: BeastPackageColors.background.opacity(0.54), location: 0.56),
                    .init(color: BeastPackageColors.background.opacity(0.18), location: 0.80),
                    .init(color: BeastPackageColors.background.opacity(0.0), location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var headerAccent: Color {
        colorScheme == .dark
        ? Color("BeastYellowPrimary")
        : Color("BeastAccent")
    }
}
