import SwiftUI

struct PasswordRequirementItem: View {
    let title: String
    let isCompleted: Bool

    var body: some View {
        HStack(
            spacing: 7
        ) {
            Image(
                systemName:
                    isCompleted
                    ? "checkmark.circle.fill"
                    : "circle.fill"
            )
            .font(
                .system(
                    size: 11,
                    weight: .bold
                )
            )
            .foregroundStyle(
                isCompleted
                ? BeastColors.primary
                : Color.gray
            )

            Text(title)
                .font(
                    .system(
                        size: 8,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    isCompleted
                    ? BeastColors.primary
                    : Color.gray
                )

            Spacer(
                minLength: 0
            )
        }
    }
}
