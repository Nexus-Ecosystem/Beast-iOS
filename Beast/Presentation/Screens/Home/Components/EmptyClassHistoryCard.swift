import SwiftUI

struct EmptyClassHistoryCard: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(
                        BeastColors.surface
                    )
                    .frame(
                        width: 64,
                        height: 64
                    )

                Image(
                    systemName: "dumbbell.fill"
                )
                .font(
                    .system(
                        size: 26,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.29,
                        green: 0.33,
                        blue: 0.18
                    )
                )
            }

            Text(
                "No tienes historial de clases"
            )
            .font(
                .system(
                    size: 18,
                    weight: .black
                )
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .multilineTextAlignment(.center)
            .padding(.top, 24)

            Text(
                "Te invitamos a registrar tu primera clase en la sección de (AGENDA)"
            )
            .font(
                .system(
                    size: 12,
                    weight: .regular
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(
            BeastColors.surface
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 32,
                style: .continuous
            )
        )
    }
}
