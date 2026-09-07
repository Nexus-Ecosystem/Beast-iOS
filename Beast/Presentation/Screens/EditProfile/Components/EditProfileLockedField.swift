import SwiftUI

struct EditProfileLockedField: View {
    let title: String
    let value: String
    let helper: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            HStack {
                Text(
                    title
                )
                .font(
                    .system(
                        size: 9,
                        weight: .black
                    )
                )
                .tracking(1)
                .foregroundStyle(
                    BeastColors.primary
                )

                Spacer()

                Image(
                    systemName:
                        "lock.fill"
                )
                .font(
                    .system(
                        size: 10
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
            }
            .padding(
                .horizontal,
                8
            )

            Text(
                value
            )
            .font(
                .system(
                    size: 13,
                    weight: .medium
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(
                .horizontal,
                20
            )
            .frame(
                height: 52
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 22
                )
                .fill(
                    BeastColors.surface
                )
            )

            Text(
                helper
            )
            .font(
                .system(
                    size: 9
                )
            )
            .italic()
            .foregroundStyle(
                BeastColors.textSecondary
                    .opacity(
                        0.65
                    )
            )
            .padding(
                .horizontal,
                8
            )
        }
    }
}
