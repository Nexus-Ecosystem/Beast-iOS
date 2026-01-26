import SwiftUI

struct LoginHeaderView: View {
    let title: String
    let subtitle: String
    let description: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color("BeastSurface"))
                    .frame(width: 64, height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color("BeastBorder"), lineWidth: 1)
                    )

                Image(systemName: "bicycle")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color("BeastYellowPrimary"))
            }

            Text(title)
                .font(.title2.weight(.heavy))
                .foregroundStyle(Color("BeastTextPrimary"))

            Text(subtitle)
                .font(.title3.weight(.bold))
                .foregroundStyle(Color("BeastTextPrimary"))
                .padding(.top, 2)

            Text(description)
                .font(.subheadline)
                .foregroundStyle(Color("BeastTextSecondary"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
    }
}
