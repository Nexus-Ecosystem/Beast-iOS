import SwiftUI

struct PopularPackageCardView: View {

    let package: PackagePlan
    let width: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundImage
            darkOverlay
            content
        }
        .frame(width: width, height: 390)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
        .shadow(
            color: BeastPackageColors.accent.opacity(0.18),
            radius: 18,
            x: 0,
            y: 10
        )
    }

    private var backgroundImage: some View {
        Image(package.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: 390)
            .clipped()
    }

    private var darkOverlay: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.76),
                .black.opacity(0.54),
                .black.opacity(0.82)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: width, height: 390)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(package.badge ?? "")
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .tracking(1)
                .foregroundStyle(.white.opacity(0.88))
                .padding(.horizontal, 12)
                .frame(height: 30)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

            VStack(alignment: .leading, spacing: 4) {
                Text(package.name)
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .italic()
                    .foregroundStyle(BeastPackageColors.yellowPrimary)

                Text(package.description)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.72))
                    .lineLimit(2)
            }

            HStack(alignment: .lastTextBaseline, spacing: 5) {
                Text(package.price)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(BeastPackageColors.yellowAccent)

                if let period = package.period {
                    Text("/ \(period)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }

            VStack(alignment: .leading, spacing: 9) {
                ForEach(package.benefits.prefix(3), id: \.self) { benefit in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.green)

                        Text(benefit)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                }
            }

            Spacer(minLength: 8)

            Button {

            } label: {
                Text("MEJORAR PLAN")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundStyle(.black)
                    .frame(width: width - 40, height: 48)
                    .background(BeastPackageColors.yellowPrimary)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Text(package.footer?.uppercased() ?? "")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.55))
                .lineLimit(1)
                .frame(width: width - 40)
        }
        .frame(width: width - 40, height: 342, alignment: .topLeading)
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 24)
    }
}
