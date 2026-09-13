import SwiftUI

struct SpecialPackageCard: View {
    let package: PaqueteMemberShipModel
    let isActive: Bool
    let buttonTitle: String
    let canBuy: Bool
    let onAction: () -> Void

    private var imageURL: URL? {
        let value = package.imagePlan.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !value.isEmpty else {
            return nil
        }

        return URL(string: value)
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            packageImage
                .frame(height: 105)
                .clipped()

            VStack(
                alignment: .leading,
                spacing: 7
            ) {
                Text(
                    isActive
                    ? "PAQUETE ACTIVO"
                    : "PAQUETE"
                )
                .font(
                    .system(
                        size: 9,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    Color("BeastTabSelected")
                )

                Text(package.name)
                    .font(
                        .system(
                            size: 17,
                            weight: .black
                        )
                    )
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text(package.descripcion)
                    .font(
                        .system(
                            size: 11,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(priceText)
                    .font(
                        .system(
                            size: 20,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        Color("BeastTabSelected")
                    )
                    .padding(.top, 2)

                Spacer(minLength: 4)

                Button(
                    action: onAction
                ) {
                    Text(
                        isActive
                        ? buttonTitle
                        : "ADQUIRIR"
                    )
                    .font(
                        .system(
                            size: 11,
                            weight: .black
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 38)
                    .background(
                        Color("BeastTabSelected")
                    )
                    .clipShape(
                        Capsule()
                    )
                }
                .disabled(!canBuy)
                .opacity(
                    canBuy
                    ? 1
                    : 0.65
                )
            }
            .padding(12)
        }
        .background(
            Color("BeastTabBackground")
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }

    @ViewBuilder
    private var packageImage: some View {
        if let imageURL {
            AsyncImage(
                url: imageURL
            ) { phase in
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

    private var priceText: String {
        let price =
            package.precioDescuento > 0
            ? package.precioDescuento
            : package.precioRegular

        return "$\(Int(price))"
    }
}
