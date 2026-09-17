import SwiftUI

struct SpecialPackageCard: View {

    let package: PaqueteMemberShipModel
    let isActive: Bool
    let buttonTitle: String
    let canBuy: Bool
    let onAction: () -> Void

    private var imageURL: URL? {
        let value = package.imagePlan
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else {
            return nil
        }

        return URL(string: value)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection

            VStack(alignment: .leading, spacing: 10) {
                if isActive {
                    activeBadge
                }

                Text(package.name.uppercased())
                    .font(.system(size: 17, weight: .black))
                    .italic()
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                if !package.descripcion.isEmpty {
                    Text(package.descripcion)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }

                validityRow

                priceRow

                if !package.beneficios.isEmpty {
                    VStack(
                        alignment: .leading,
                        spacing: 6
                    ) {
                        ForEach(
                            Array(
                                package.beneficios
                                    .prefix(2)
                                    .enumerated()
                            ),
                            id: \.offset
                        ) { _, benefit in
                            benefitRow(benefit)
                        }
                    }
                }

                Spacer(minLength: 4)

                Button(action: onAction) {
                    Text(buttonTitle)
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            Color("BeastTabSelected")
                        )
                        .clipShape(Capsule())
                }
                .disabled(!canBuy)
                .opacity(canBuy ? 1 : 0.65)
            }
            .padding(14)
        }
        .background(
            Color("BeastBackground")
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                Color.primary.opacity(0.08),
                lineWidth: 1
            )
        }
    }

    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            remoteImage
                .frame(height: 135)
                .frame(maxWidth: .infinity)
                .clipped()

            if isActive {
                Image(systemName: "star.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(9)
                    .background(
                        Color("BeastTabSelected")
                    )
                    .clipShape(Circle())
                    .padding(10)
            }
        }
    }

    private var validityRow: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )

            Text(
                "Vigencia: \(package.diasVigencia) días"
            )
            .font(
                .system(
                    size: 12,
                    weight: .semibold
                )
            )
            .lineLimit(1)
            .minimumScaleFactor(0.75)
        }
        .foregroundStyle(.secondary)
    }

    private var priceRow: some View {
        HStack(
            alignment: .firstTextBaseline,
            spacing: 4
        ) {
            Text(priceText)
                .font(
                    .system(
                        size: 22,
                        weight: .black
                    )
                )
                .foregroundStyle(.primary)

            Text("/ mes")
                .font(
                    .system(
                        size: 11,
                        weight: .bold
                    )
                )
                .foregroundStyle(.secondary)
        }
    }

    private var activeBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: "star.fill")
                .font(
                    .system(
                        size: 8,
                        weight: .bold
                    )
                )

            Text("PAQUETE ACTIVO")
                .font(
                    .system(
                        size: 9,
                        weight: .black
                    )
                )
        }
        .foregroundStyle(
            Color("BeastTabSelected")
        )
    }

    @ViewBuilder
    private var remoteImage: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    fallbackImage

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    fallbackImage

                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        Image("default_image_plan")
            .resizable()
            .scaledToFill()
    }

    private func benefitRow(
        _ text: String
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 6
        ) {
            Image(
                systemName: "checkmark.circle.fill"
            )
            .font(
                .system(
                    size: 12,
                    weight: .bold
                )
            )
            .foregroundStyle(.green)

            Text(text)
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }

    private var priceText: String {
        let price =
            package.precioDescuento > 0
            ? package.precioDescuento
            : package.precioRegular

        return "$\(Int(price))"
    }
}
