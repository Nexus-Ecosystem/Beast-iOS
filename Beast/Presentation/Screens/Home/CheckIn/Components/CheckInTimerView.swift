import SwiftUI

struct CheckInTimerView: View {
    let time: String

    var body: some View {
        HStack(spacing: 8) {
            Image(
                systemName: "timer"
            )
            .font(
                .system(
                    size: 15,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "ACTUALIZACIÓN EN \(time)"
            )
            .font(
                .system(
                    size: 11,
                    weight: .bold
                )
            )
            .tracking(1)
            .foregroundStyle(
                BeastColors.textPrimary
            )
        }
        .padding(
            .horizontal,
            16
        )
        .padding(
            .vertical,
            10
        )
        .background(
            BeastColors.surface
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }
}
