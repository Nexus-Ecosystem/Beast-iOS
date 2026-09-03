import SwiftUI

struct ClassHistoryItem: View {
    let reservation: ClassItemEntity

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        BeastColors.background
                    )
                    .frame(
                        width: 48,
                        height: 48
                    )

                Image(
                    systemName: "bolt.fill"
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(
                    reservation.name
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .lineLimit(1)

                Text(
                    "\(reservation.diaAgendado)\n• Coach \(reservation.coach)"
                )
                .font(
                    .system(
                        size: 12
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .lineLimit(2)
            }

            Spacer()

            Text("Tomada")
                .font(
                    .system(
                        size: 9,
                        weight: .black
                    )
                )
                .tracking(1)
                .foregroundStyle(
                    .black
                )
                .padding(
                    .horizontal,
                    10
                )
                .padding(
                    .vertical,
                    5
                )
                .background(
                    Color(
                        red: 0,
                        green: 0.90,
                        blue: 0.46
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                )
        }
        .padding(
            .horizontal,
            20
        )
        .padding(
            .vertical,
            16
        )
        .background(
            BeastColors.surface
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }
}
