import SwiftUI

struct PurchaseConfirmationDialog: View {
    let package: PaqueteMemberShipModel
    let userName: String
    let userPhone: String
    let administrationPhone: String
    let onDismiss: () -> Void

    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            icon

            Text("CONFIRMAR COMPRA")
                .font(.system(size: 23, weight: .black))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.top, 16)

            Text(package.name.uppercased())
                .font(.system(size: 15, weight: .black))
                .italic()
                .foregroundStyle(Color("BeastTabSelected"))
                .multilineTextAlignment(.center)
                .padding(.top, 7)

            Text(priceText)
                .font(.system(size: 21, weight: .black))
                .padding(.top, 4)

            Divider()
                .padding(.vertical, 17)

            Text(
                "Serás redirigido a nuestro WhatsApp de administración para completar tu pago y activar tu membresía."
            )
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .fixedSize(horizontal: false, vertical: true)

            Button {
                openWhatsApp()
            } label: {
                HStack(spacing: 8) {
                    Text("CONTINUAR")
                    Image(systemName: "arrow.up.right")
                }
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    canContinue
                        ? Color("BeastTabSelected")
                        : Color.gray.opacity(0.55)
                )
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!canContinue)
            .padding(.top, 22)

            Button {
                onDismiss()
            } label: {
                Text("CANCELAR")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(2.5)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: 360)
        .padding(.horizontal, 24)
        .padding(.top, 28)
        .padding(.bottom, 6)
        .background(Color(.systemBackground))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
            .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        }
        .shadow(
            color: .black.opacity(0.28),
            radius: 30,
            y: 16
        )
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(Color("BeastTabSelected").opacity(0.12))
                .frame(width: 66, height: 66)

            Circle()
                .stroke(
                    Color("BeastTabSelected").opacity(0.18),
                    lineWidth: 1
                )
                .frame(width: 66, height: 66)

            Image(systemName: "creditcard.fill")
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(Color("BeastTabSelected"))
        }
    }

    private var canContinue: Bool {
        !cleanAdministrationPhone.isEmpty
    }

    private var cleanAdministrationPhone: String {
        administrationPhone.filter(\.isNumber)
    }

    private var priceText: String {
        let price = package.precioDescuento > 0
            ? package.precioDescuento
            : package.precioRegular

        return "$\(Int(price)) MXN"
    }

    private func openWhatsApp() {
        guard canContinue else { return }

        let message = """
        Hola, quiero adquirir el paquete \(package.name).

        Cliente: \(userName)
        Teléfono: \(userPhone)
        Paquete: \(package.name)
        Precio: \(priceText)
        """

        guard
            let encodedMessage = message.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(
                string: "https://api.whatsapp.com/send?phone=\(cleanAdministrationPhone)&text=\(encodedMessage)"
            )
        else { return }

        openURL(url)
    }
}
