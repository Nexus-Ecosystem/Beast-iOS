import SwiftUI

struct VerificationShieldView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .fill(
                BeastColors.surface
            )
            .frame(
                width: 82,
                height: 82
            )

            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .stroke(
                BeastColors.border,
                lineWidth: 1
            )
            .frame(
                width: 82,
                height: 82
            )

            Image(
                systemName:
                    "checkmark.shield.fill"
            )
            .font(
                .system(
                    size: 40,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )
        }
    }
}
