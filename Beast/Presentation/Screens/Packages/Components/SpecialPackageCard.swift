import SwiftUI

struct SpecialPackageCard: View {
    let package: PaqueteMemberShipModel
    let isActive: Bool
    let buttonTitle: String
    let canBuy: Bool
    let onDetail: () -> Void
    let onBuy: () -> Void

    private let imageHeight: CGFloat = 130
    private let contentHeight: CGFloat = 150

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onDetail) {
                VStack(spacing: 0) {
                    imageSection
                    content
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            buyButton
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
        }
        .background(Color(.systemBackground))
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
                Color.primary.opacity(0.07),
                lineWidth: 1
            )
        }
        .shadow(
            color: .black.opacity(0.06),
            radius: 10,
            y: 4
        )
    }

    // MARK: - Image

    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            packageImage
                .frame(maxWidth: .infinity)
                .frame(height: imageHeight)
                .clipped()

            if isActive {
                Text("ACTIVO")
                    .font(
                        .system(
                            size: 8,
                            weight: .black
                        )
                    )
                    .tracking(0.6)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(
                        Color("BeastTabSelected")
                    )
                    .clipShape(Capsule())
                    .padding(9)
            }
        }
        .frame(height: imageHeight)
    }

    @ViewBuilder
    private var packageImage: some View {
        if let imageURL {
            AsyncImage(
                url: imageURL
            ) { phase in
                switch phase {
                case .empty:
                    defaultImage
                        .overlay {
                            ProgressView()
                                .tint(.white)
                        }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(
                            height: imageHeight
                        )
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
            .frame(height: imageHeight)
            .clipped()
    }

    // MARK: - Content

    private var content: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            Text(package.name)
                .font(
                    .system(
                        size: 16,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .allowsTightening(true)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

            if !package.descripcion.isEmpty {
                Text(package.descripcion)
                    .font(
                        .system(
                            size: 10,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.top, 5)
            }

            Spacer(minLength: 7)

            weekendText

            validityRow
                .padding(.top, 5)

            Spacer(minLength: 6)

            priceRow
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .frame(height: contentHeight)
        .padding(.horizontal, 14)
        .padding(.top, 13)
        .padding(.bottom, 10)
    }

    // MARK: - Weekend

    private var weekendText: some View {
        Text(
            package.incluyeFinesDeSemana
                ? "SI incluye fines de semana"
                : "NO incluye fines de semana"
        )
        .font(
            .system(
                size: 8.5,
                weight: .bold
            )
        )
        .foregroundStyle(
            package.incluyeFinesDeSemana
                ? Color.green
                : Color.red
        )
        .lineLimit(1)
        .minimumScaleFactor(0.65)
    }

    // MARK: - Validity

    private var validityRow: some View {
        HStack(spacing: 5) {
            Image(
                systemName: "calendar"
            )
            .font(
                .system(
                    size: 9,
                    weight: .semibold
                )
            )

            Text(
                "Vigencia: \(package.diasVigencia) días"
            )
            .font(
                .system(
                    size: 9,
                    weight: .bold
                )
            )
            .lineLimit(1)
            .minimumScaleFactor(0.75)
        }
        .foregroundStyle(.secondary)
    }

    // MARK: - Price

    private var priceRow: some View {
        HStack(
            alignment: .firstTextBaseline,
            spacing: 4
        ) {
            Text(priceText)
                .font(
                    .system(
                        size: 23,
                        weight: .black
                    )
                )
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text("MXN")
                .font(
                    .system(
                        size: 8,
                        weight: .black
                    )
                )
                .foregroundStyle(.secondary)

            Spacer()

            Image(
                systemName: "chevron.right"
            )
            .font(
                .system(
                    size: 10,
                    weight: .bold
                )
            )
            .foregroundStyle(
                .secondary.opacity(0.6)
            )
        }
    }

    // MARK: - Button

    private var buyButton: some View {
        Button {
            guard canBuy else {
                return
            }

            onBuy()
        } label: {
            HStack(spacing: 5) {
                Text(buttonTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                if canBuy {
                    Image(
                        systemName: "arrow.right"
                    )
                } else {
                    Image(
                        systemName: "checkmark"
                    )
                }
            }
            .font(
                .system(
                    size: 9,
                    weight: .black
                )
            )
            .foregroundStyle(
                canBuy
                    ? Color.white
                    : Color.secondary
            )
            .frame(maxWidth: .infinity)
            .frame(height: 42)
            .background(
                canBuy
                    ? Color("BeastTabSelected")
                    : Color.secondary.opacity(0.12)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!canBuy)
    }

    // MARK: - Helpers

    private var imageURL: URL? {
        let value =
            package.imagePlan
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        guard
            !value.isEmpty,
            let url = URL(
                string: value
            ),
            let scheme =
                url.scheme?.lowercased(),
            scheme == "https" ||
                scheme == "http"
        else {
            return nil
        }

        return url
    }

    private var priceText: String {
        let price =
            package.precioDescuento > 0
                ? package.precioDescuento
                : package.precioRegular

        return "$\(Int(price))"
    }
}
