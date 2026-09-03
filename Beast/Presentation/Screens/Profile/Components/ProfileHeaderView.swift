import SwiftUI

struct ProfileHeaderView: View {

    var body: some View {
        ZStack {
            headerBackground

            HStack {
                Text("Perfil")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .italic()
                    .foregroundStyle(BeastProfileColors.accent)

                Spacer()

                Button {

                } label: {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Circle()
                                    .stroke(BeastProfileColors.border.opacity(0.45), lineWidth: 1)
                            }

                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 17, weight: .heavy))
                            .foregroundStyle(BeastProfileColors.accent)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 22)
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
                            .init(color: .black.opacity(1.0), location: 0.00),
                            .init(color: .black.opacity(0.96), location: 0.18),
                            .init(color: .black.opacity(0.78), location: 0.42),
                            .init(color: .black.opacity(0.38), location: 0.68),
                            .init(color: .black.opacity(0.0), location: 1.00)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            LinearGradient(
                stops: [
                    .init(color: BeastProfileColors.background.opacity(0.98), location: 0.00),
                    .init(color: BeastProfileColors.background.opacity(0.86), location: 0.26),
                    .init(color: BeastProfileColors.background.opacity(0.54), location: 0.56),
                    .init(color: BeastProfileColors.background.opacity(0.18), location: 0.80),
                    .init(color: BeastProfileColors.background.opacity(0.0), location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            LinearGradient(
                stops: [
                    .init(color: BeastProfileColors.accent.opacity(0.16), location: 0.00),
                    .init(color: BeastProfileColors.accent.opacity(0.10), location: 0.28),
                    .init(color: BeastProfileColors.accent.opacity(0.04), location: 0.58),
                    .init(color: BeastProfileColors.accent.opacity(0.0), location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
