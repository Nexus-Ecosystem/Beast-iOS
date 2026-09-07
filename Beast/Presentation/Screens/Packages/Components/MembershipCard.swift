import SwiftUI

struct MembershipCard: View {
    let package: PaqueteMemberShipModel
    let isActive: Bool
    let isExpired: Bool
    let isEmpty: Bool
    let actionTitle: String
    let actionEnabled: Bool
    let onBuy: () -> Void

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack(
                alignment: .top
            ) {
                badge

                Spacer()

                if isActive {
                    Image(
                        systemName: "star.fill"
                    )
                    .font(
                        .system(
                            size: 18,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )
                }
            }

            Text(
                package.name.uppercased()
            )
            .font(
                .system(
                    size: 23,
                    weight: .black
                )
            )
            .italic()
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .padding(
                .top,
                10
            )

            if !package.descripcion.isEmpty {
                Text(
                    package.descripcion
                )
                .font(
                    .system(
                        size: 12
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .padding(
                    .top,
                    6
                )
            }

            Text(
                formattedPrice
            )
            .font(
                .system(
                    size: 22,
                    weight: .black
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )
            .padding(
                .top,
                14
            )

            if !package.beneficios.isEmpty {
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    ForEach(
                        package.beneficios,
                        id: \.self
                    ) { benefit in
                        HStack(
                            spacing: 9
                        ) {
                            Image(
                                systemName:
                                    "checkmark.circle.fill"
                            )
                            .font(
                                .system(
                                    size: 14
                                )
                            )
                            .foregroundStyle(
                                BeastColors.primary
                            )

                            Text(
                                benefit
                            )
                            .font(
                                .system(
                                    size: 11,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(
                                BeastColors.textSecondary
                            )
                        }
                    }
                }
                .padding(
                    .top,
                    18
                )
            }

            Button {
                if actionEnabled {
                    onBuy()
                }
            } label: {
                Text(
                    actionTitle
                )
                .font(
                    .system(
                        size: 12,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    actionEnabled
                    ? BeastColors.buttonText
                    : BeastColors.textSecondary
                )
                .frame(
                    maxWidth: .infinity
                )
                .frame(
                    height: 48
                )
                .background(
                    Capsule()
                        .fill(
                            actionEnabled
                            ? BeastColors.primary
                            : BeastColors.border
                        )
                )
            }
            .buttonStyle(
                .plain
            )
            .disabled(
                !actionEnabled
            )
            .padding(
                .top,
                24
            )
        }
        .padding(
            20
        )
        .background(
            RoundedRectangle(
                cornerRadius: 26
            )
            .fill(
                BeastColors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 26
            )
            .stroke(
                isActive
                ? BeastColors.primary
                : BeastColors.border,
                lineWidth:
                    isActive
                    ? 1.2
                    : 1
            )
        )
    }

    private var badge: some View {
        Text(
            badgeTitle
        )
        .font(
            .system(
                size: 8,
                weight: .bold
            )
        )
        .foregroundStyle(
            badgeColor
        )
        .padding(
            .horizontal,
            8
        )
        .padding(
            .vertical,
            5
        )
        .background(
            RoundedRectangle(
                cornerRadius: 6
            )
            .fill(
                badgeColor.opacity(
                    0.10
                )
            )
        )
    }

    private var badgeTitle: String {
        if isExpired {
            return "Paquete expirado"
        }

        if isActive {
            return "Paquete activo"
        }

        return "Paquete más popular"
    }

    private var badgeColor: Color {
        if isExpired {
            return BeastColors.danger
        }

        return BeastColors.primary
    }

    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.currencyCode = "MXN"
        formatter.maximumFractionDigits = 2

        return formatter.string(
            from: NSNumber(
                value: package.precioDescuento
            )
        ) ?? "$\(package.precioDescuento)"
    }
}
