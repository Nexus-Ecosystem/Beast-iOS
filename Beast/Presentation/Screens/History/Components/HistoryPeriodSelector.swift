import SwiftUI

struct HistoryPeriodSelector: View {
    let title: String
    let previous: () -> Void
    let next: () -> Void

    var body: some View {
        HStack(
            spacing: 16
        ) {
            Button {
                previous()
            } label: {
                Image(
                    systemName: "chevron.left"
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
                .frame(
                    width: 36,
                    height: 36
                )
                .background(
                    Circle()
                        .fill(
                            BeastColors.surface
                        )
                )
                .overlay(
                    Circle()
                        .stroke(
                            BeastColors.border,
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(
                .plain
            )

            Spacer()

            Text(
                title
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

            Spacer()

            Button {
                next()
            } label: {
                Image(
                    systemName: "chevron.right"
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
                .frame(
                    width: 36,
                    height: 36
                )
                .background(
                    Circle()
                        .fill(
                            BeastColors.surface
                        )
                )
                .overlay(
                    Circle()
                        .stroke(
                            BeastColors.border,
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(
                .plain
            )
        }
    }
}
