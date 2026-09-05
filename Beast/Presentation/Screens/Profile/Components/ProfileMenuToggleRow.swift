import SwiftUI

struct ProfileMenuToggleRow: View {
    let icon: String
    let title: String

    @Binding var isOn: Bool

    var body: some View {
        HStack(
            spacing: 16
        ) {
            Image(
                systemName: icon
            )
            .font(
                .system(
                    size: 17,
                    weight: .medium
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )
            .frame(width: 22)

            Text(title)
                .font(
                    .system(
                        size: 15,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    .primary
                )

            Spacer()

            Toggle(
                "",
                isOn: $isOn
            )
            .labelsHidden()
            .tint(
                BeastColors.primary
            )
            .scaleEffect(0.86)
        }
        .frame(minHeight: 56)
        .padding(
            .horizontal,
            18
        )
    }
}
