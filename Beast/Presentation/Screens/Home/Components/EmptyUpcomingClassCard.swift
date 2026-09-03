import SwiftUI

struct EmptyUpcomingClassCard: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(BeastColors.background)
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

            Text("NO HAY PRÓXIMA CLASE")
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
                "Listo para tu siguiente reto?\nDescubre las clases de cada día y agenda en el horario que más te convenga"
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

            HStack(spacing: 8) {
                Text("Explora más clases")
                    .font(
                        .system(
                            size: 12,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Image(
                    systemName: "arrow.right"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }
            .padding(.top, 24)
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
