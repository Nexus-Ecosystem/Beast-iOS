import SwiftUI

struct SpecialPackageCardView: View {

    let package: PackagePlan
    let width: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            Image(package.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: 92)
                .clipped()

            VStack(alignment: .leading, spacing: 7) {
                Text(package.badge ?? "")
                    .font(.system(size: 8, weight: .heavy, design: .rounded))
                    .tracking(0.6)
                    .foregroundStyle(BeastPackageColors.accent)
                    .lineLimit(1)

                Text(package.name)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(BeastPackageColors.textPrimary)
                    .lineLimit(1)

                Text(package.description)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(BeastPackageColors.textSecondary)
                    .lineLimit(2)

                Text(package.price)
                    .font(.system(size: 19, weight: .heavy, design: .rounded))
                    .foregroundStyle(BeastPackageColors.accent)

                Spacer(minLength: 4)

                Button {

                } label: {
                    Text("COMPRAR")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color("BeastBackground"))
                        .frame(width: width - 24, height: 36)
                        .background(BeastPackageColors.accent)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .frame(width: width - 24, height: 136, alignment: .topLeading)
            .padding(12)
        }
        .frame(width: width, height: 252)
        .background(BeastPackageColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(BeastPackageColors.border.opacity(0.62), lineWidth: 1)
        }
        .shadow(
            color: .black.opacity(0.055),
            radius: 10,
            x: 0,
            y: 6
        )
    }
}
