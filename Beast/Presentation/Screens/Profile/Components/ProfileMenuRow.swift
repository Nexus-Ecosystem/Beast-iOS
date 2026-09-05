import SwiftUI

struct ProfileMenuRow: View {
    let icon: String
    let title: String

    var value: String? = nil
    var showChevron = true

    let action: () -> Void

    var body: some View {
        Button(
            action: action
        ) {
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

                if let value {
                    Text(value)
                        .font(
                            .system(
                                size: 11,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )
                }

                if showChevron {
                    Image(
                        systemName: "chevron.right"
                    )
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
            }
            .frame(minHeight: 56)
            .padding(
                .horizontal,
                18
            )
        }
        .buttonStyle(.plain)
    }
}
