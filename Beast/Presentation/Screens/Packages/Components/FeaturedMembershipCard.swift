import SwiftUI

struct FeaturedMembershipCard: View {
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

    private var badgeTitle: String {
        isActive
        ? "PAQUETE ACTIVO"
        : "MÁS POPULAR"
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                badge

                Spacer()
                    .frame(
                        minHeight: 125
                    )

                Text(
                    package.name.uppercased()
                )
                .font(
                    .system(
                        size: 30,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

                if !package.descripcion.isEmpty {
                    Text(
                        package.descripcion
                            .uppercased()
                    )
                    .font(
                        .system(
                            size: 15,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(0.8)
                    )
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                }

                Text(priceText)
                    .font(
                        .system(
                            size: 31,
                            weight: .black
                        )
                    )
                    .foregroundStyle(.white)

                if !package.beneficios.isEmpty {
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        ForEach(
                            Array(
                                package.beneficios
                                    .prefix(3)
                                    .enumerated()
                            ),
                            id: \.offset
                        ) { _, benefit in
                            benefitRow(
                                benefit
                            )
                        }
                    }
                    .padding(.top, 2)
                }

                Button(
                    action: onAction
                ) {
                    Text(buttonTitle)
                        .font(
                            .system(
                                size: 14,
                                weight: .black
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(height: 52)
                        .background(
                            Color(
                                "BeastTabSelected"
                            )
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
                .padding(.top, 8)
            }
            .padding(20)
        }
        .background {
            ZStack {
                remoteImage

                LinearGradient(
                    colors: [
                        .black.opacity(0.05),
                        .black.opacity(0.35),
                        .black.opacity(0.92)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
        .contentShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
    }

    private var badge: some View {
        HStack(spacing: 6) {
            if isActive {
                Image(
                    systemName: "star.fill"
                )
                .font(
                    .system(
                        size: 10,
                        weight: .bold
                    )
                )
            }

            Text(badgeTitle)
                .font(
                    .system(
                        size: 11,
                        weight: .black
                    )
                )
        }
        .foregroundStyle(.white)
        .padding(
            .horizontal,
            14
        )
        .padding(
            .vertical,
            7
        )
        .background(
            Color("BeastTabSelected")
        )
        .clipShape(
            Capsule()
        )
    }

    @ViewBuilder
    private var remoteImage: some View {
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

    private func benefitRow(
        _ text: String
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 9
        ) {
            Image(
                systemName:
                    "checkmark.circle.fill"
            )
            .font(
                .system(
                    size: 16,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.green
            )

            Text(text)
                .font(
                    .system(
                        size: 13,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    .white.opacity(0.92)
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
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
