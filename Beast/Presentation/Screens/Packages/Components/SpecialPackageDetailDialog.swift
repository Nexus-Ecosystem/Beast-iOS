import SwiftUI

struct SpecialPackageDetailDialog: View {
    let package: PaqueteMemberShipModel
    let canBuy: Bool
    let buttonTitle: String
    let onDismiss: () -> Void
    let onBuy: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            imageSection
            content
        }
        .frame(maxWidth: 360)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.28), radius: 28, y: 12)
        .overlay(alignment: .topTrailing) {
            closeButton
        }
    }

    // MARK: - Image

    private var imageSection: some View {
        ZStack {
            packageImage
                .frame(maxWidth: .infinity)
                .frame(height: 185)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.12)],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .frame(height: 185)
    }

    @ViewBuilder
    private var packageImage: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
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
            .frame(height: 185)
            .clipped()
    }

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(package.name)
                .font(.system(size: 20, weight: .black))
                .italic()
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.68)
                .allowsTightening(true)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !package.descripcion.isEmpty {
                Text(package.descripcion)
                    .font(.system(size: 10.5, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineSpacing(1.5)
                    .lineLimit(3)
                    .padding(.top, 5)
            }

            HStack(spacing: 10) {
                weekendRow

                Spacer(minLength: 4)

                validityRow
            }
            .padding(.top, 9)

            benefits
                .padding(.top, 9)

            HStack(alignment: .center, spacing: 12) {
                priceRow

                Spacer(minLength: 4)

                buyButton
                    .frame(width: 142)
            }
            .padding(.top, 13)
        }
        .padding(.horizontal, 18)
        .padding(.top, 14)
        .padding(.bottom, 16)
    }

    // MARK: - Weekend

    private var weekendRow: some View {
        HStack(spacing: 4) {
            Image(
                systemName: package.incluyeFinesDeSemana
                    ? "checkmark.circle.fill"
                    : "xmark.circle.fill"
            )

            Text(
                package.incluyeFinesDeSemana
                    ? "Incluye fin de semana"
                    : "Sin fin de semana"
            )
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        }
        .font(.system(size: 9.5, weight: .bold))
        .foregroundStyle(
            package.incluyeFinesDeSemana
                ? Color.green
                : Color.red
        )
    }

    // MARK: - Validity

    private var validityRow: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.system(size: 9, weight: .semibold))

            Text("\(package.diasVigencia) días")
                .font(.system(size: 9.5, weight: .bold))
                .lineLimit(1)
        }
        .foregroundStyle(.secondary)
    }

    // MARK: - Benefits

    @ViewBuilder
    private var benefits: some View {
        if !package.beneficios.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(
                    Array(package.beneficios.prefix(3).enumerated()),
                    id: \.offset
                ) { _, benefit in
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.green)

                        Text(benefit)
                            .font(.system(size: 9.5, weight: .medium))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }
                }
            }
        }
    }

    // MARK: - Price

    private var priceRow: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("PRECIO")
                .font(.system(size: 7.5, weight: .black))
                .tracking(1)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(priceText)
                    .font(.system(size: 24, weight: .black))
                    .lineLimit(1)

                Text("MXN")
                    .font(.system(size: 8, weight: .black))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Buy

    private var buyButton: some View {
        Button {
            guard canBuy else { return }
            onBuy()
        } label: {
            HStack(spacing: 5) {
                Text(buttonTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                Image(systemName: canBuy ? "arrow.right" : "checkmark")
            }
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(canBuy ? .white : .secondary)
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

    // MARK: - Close

    @ViewBuilder
    private var closeButton: some View {
        if #available(iOS 26.0, *) {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(width: 38, height: 38)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .padding(12)
        } else {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(width: 38, height: 38)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 0.8)
                    }
            }
            .buttonStyle(.plain)
            .padding(12)
        }
    }

    // MARK: - Helpers

    private var imageURL: URL? {
        let value = package.imagePlan
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty,
              let url = URL(string: value),
              let scheme = url.scheme?.lowercased(),
              scheme == "https" || scheme == "http"
        else {
            return nil
        }

        return url
    }

    private var priceText: String {
        let price = package.precioDescuento > 0
            ? package.precioDescuento
            : package.precioRegular

        return "$\(Int(price))"
    }
}
