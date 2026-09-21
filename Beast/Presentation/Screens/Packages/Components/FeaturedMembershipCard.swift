import SwiftUI

struct FeaturedMembershipCard: View {
    let package: PaqueteMemberShipModel
    let isActive: Bool
    let buttonTitle: String
    let canBuy: Bool
    let onBuy: () -> Void

    private let cardHeight: CGFloat = 320

    var body: some View {
        ZStack {
            packageImage

            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.18), location: 0),
                    .init(color: .black.opacity(0.30), location: 0.28),
                    .init(color: .black.opacity(0.58), location: 0.60),
                    .init(color: .black.opacity(0.92), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.55), location: 0),
                    .init(color: .black.opacity(0.30), location: 0.48),
                    .init(color: .black.opacity(0.08), location: 0.78),
                    .init(color: .clear, location: 1)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            content
        }
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.12), radius: 12, y: 5)
    }

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            topRow

            Spacer(minLength: 8)

            packageName

            if !package.descripcion.isEmpty {
                description.padding(.top, 4)
            }

            weekendLabel.padding(.top, 7)
            validity.padding(.top, 5)
            price.padding(.top, 7)
            benefits.padding(.top, 5)

            Spacer(minLength: 7)

            actionButton
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    // MARK: - Top

    private var topRow: some View {
        HStack(spacing: 10) {
            if isActive {
                Text("PAQUETE ACTIVO")
                    .font(.system(size: 8, weight: .black))
                    .tracking(0.4)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(.black.opacity(0.55)))
                    .overlay {
                        Capsule().stroke(.white.opacity(0.22), lineWidth: 0.6)
                    }
            }

            Spacer()

            Image(systemName: "star.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.yellow)
                .shadow(color: .black.opacity(0.35), radius: 3, y: 1)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Name

    private var packageName: some View {
        Text(package.name)
            .font(.system(size: 24, weight: .black))
            .italic()
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
            .allowsTightening(true)
            .shadow(color: .black.opacity(0.45), radius: 2, y: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Description

    private var description: some View {
        Text(package.descripcion)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(.white.opacity(0.95))
            .lineSpacing(1.5)
            .lineLimit(4)
            .shadow(color: .black.opacity(0.45), radius: 1, y: 1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Weekend

    private var weekendLabel: some View {
        Text(package.incluyeFinesDeSemana ? "* SI incluye fines de semana *" : "* NO incluye fines de semana *")
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(package.incluyeFinesDeSemana ? Color.green : Color.red)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .shadow(color: .black.opacity(0.55), radius: 1, y: 1)
    }

    // MARK: - Validity

    private var validity: some View {
        HStack(spacing: 5) {
            Image(systemName: "calendar")
                .font(.system(size: 9, weight: .bold))

            Text("Vigencia: \(package.diasVigencia) días")
                .font(.system(size: 9.5, weight: .bold))
                .lineLimit(1)
        }
        .foregroundStyle(.white.opacity(0.95))
        .shadow(color: .black.opacity(0.45), radius: 1, y: 1)
    }

    // MARK: - Price

    private var price: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(priceText)
                .font(.system(size: 25, weight: .black))
                .foregroundStyle(.white)
                .lineLimit(1)

            Text("/ mes")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.white.opacity(0.82))
        }
        .shadow(color: .black.opacity(0.45), radius: 2, y: 1)
    }

    // MARK: - Benefits

    @ViewBuilder
    private var benefits: some View {
        if !package.beneficios.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(package.beneficios.prefix(3).enumerated()), id: \.offset) { _, benefit in
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.green)

                        Text(benefit)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.white.opacity(0.95))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .shadow(color: .black.opacity(0.45), radius: 1, y: 1)
                }
            }
        }
    }

    // MARK: - Button

    private var actionButton: some View {
        Button {
            guard canBuy else { return }
            onBuy()
        } label: {
            HStack(spacing: 6) {
                Text(buttonTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)

                if canBuy {
                    Image(systemName: "arrow.right")
                }
            }
            .font(.system(size: 9, weight: .black))
            .foregroundStyle(canBuy ? Color.black : Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Capsule().fill(canBuy ? Color("BeastTabSelected") : Color.white.opacity(0.55)))
        }
        .buttonStyle(.plain)
        .disabled(!canBuy)
    }

    // MARK: - Image

    @ViewBuilder
    private var packageImage: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    defaultImage.overlay { ProgressView().tint(.white) }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: cardHeight)
                        .clipped()

                case .failure:
                    defaultImage

                @unknown default:
                    defaultImage
                }
            }
        } else {
            defaultImage
        }
    }

    private var defaultImage: some View {
        Image("default_image_plan")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: cardHeight)
            .clipped()
    }

    // MARK: - Helpers

    private var imageURL: URL? {
        let value = package.imagePlan.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty,
              let url = URL(string: value),
              let scheme = url.scheme?.lowercased(),
              scheme == "https" || scheme == "http" else { return nil }

        return url
    }

    private var priceText: String {
        let value = package.precioDescuento > 0 ? package.precioDescuento : package.precioRegular
        return "$\(Int(value))"
    }
}
