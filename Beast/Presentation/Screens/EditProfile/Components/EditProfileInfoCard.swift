import SwiftUI

struct EditProfileInfoCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            Text(
                title
            )
            .font(
                .system(
                    size: 8,
                    weight: .bold
                )
            )
            .foregroundStyle(
                color
            )

            Text(
                value
            )
            .font(
                .system(
                    size: 13,
                    weight: .black
                )
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .lineLimit(2)

            Spacer()
        }
        .padding(
            16
        )
        .frame(
            maxWidth: .infinity,
            minHeight: 88,
            alignment: .topLeading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 22
            )
            .fill(
                BeastColors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 22
            )
            .stroke(
                LinearGradient(
                    colors: [
                        color,
                        color.opacity(0)
                    ],
                    startPoint:
                        .leading,
                    endPoint:
                        .trailing
                ),
                lineWidth: 1
            )
        )
    }
}
