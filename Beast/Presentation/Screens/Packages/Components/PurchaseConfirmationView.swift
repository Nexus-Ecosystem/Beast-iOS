import SwiftUI

struct PurchaseConfirmationView: View {
    @Environment(\.openURL) private var openURL

    let package: PaqueteMemberShipModel
    let userName: String
    let phone: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.72)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 0) {
                purchaseIcon

                VStack(spacing: 0) {
                    Text("CONFIRMAR")
                    Text("COMPRA")
                }
                .font(
                    .system(
                        size: 24,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.top, 18)

                Text(
                    package.name.lowercased()
                )
                .font(
                    .system(
                        size: 14,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.primary
                )
                .padding(.top, 8)

                Text(formattedPrice)
                    .font(
                        .system(
                            size: 15,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
                    .padding(.top, 6)

                Text(
                    "Serás redirigido a nuestro WhatsApp de administración para completar tu pago de forma segura y activar tu membresía."
                )
                .font(
                    .system(
                        size: 11
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 14)
                .padding(.top, 20)

                Button {
                    openWhatsApp()
                } label: {
                    HStack(spacing: 8) {
                        Text("CONTINUAR")

                        Image(
                            systemName: "bolt.fill"
                        )
                    }
                    .font(
                        .system(
                            size: 12,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        BeastColors.buttonText
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 48)
                    .background(
                        Capsule()
                            .fill(
                                BeastColors.primary
                            )
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 24)

                Button {
                    onDismiss()
                } label: {
                    Text("CANCELAR")
                        .font(
                            .system(
                                size: 9,
                                weight: .bold
                            )
                        )
                        .tracking(2)
                        .foregroundStyle(
                            BeastColors.textSecondary
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(
                            .vertical,
                            16
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(22)
            .frame(
                maxWidth: 320
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 28
                )
                .fill(
                    BeastColors.surface
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 28
                )
                .stroke(
                    BeastColors.border,
                    lineWidth: 1
                )
            )
            .padding(
                .horizontal,
                30
            )
        }
    }

    private var purchaseIcon: some View {
        ZStack {
            Circle()
                .fill(
                    BeastColors.background
                )
                .frame(
                    width: 54,
                    height: 54
                )

            Image(
                systemName: "creditcard.fill"
            )
            .font(
                .system(
                    size: 22,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )
        }
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

    private func openWhatsApp() {
        let message =
            "¡Hola! Mi nombre es \(userName), me gustaría activar el Paquete/Plan: \(package.name)"

        guard
            let encodedMessage = message
                .addingPercentEncoding(
                    withAllowedCharacters:
                        .urlQueryAllowed
                ),
            let url = URL(
                string:
                    "https://api.whatsapp.com/send?phone=\(phone)&text=\(encodedMessage)"
            )
        else {
            return
        }

        openURL(url)
    }
}
