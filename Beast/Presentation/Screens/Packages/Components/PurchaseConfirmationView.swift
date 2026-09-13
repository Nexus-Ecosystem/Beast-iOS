import SwiftUI

struct PurchaseConfirmationView: View {

    let package: PaqueteMemberShipModel
    let userName: String
    let phone: String
    let onDismiss: () -> Void

    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.72)
                .ignoresSafeArea()

            VStack {
                Spacer()

                confirmationCard
                    .padding(.horizontal, 28)

                Spacer()
            }
        }
        .interactiveDismissDisabled()
    }

    private var confirmationCard: some View {
        VStack(spacing: 0) {
            icon

            Text("CONFIRMAR\nCOMPRA")
                .font(.system(size: 27, weight: .black))
                .italic()
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .padding(.top, 18)

            Text(package.name)
                .font(.system(size: 15, weight: .black))
                .italic()
                .foregroundStyle(
                    Color("BeastTabSelected")
                )
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            Text(priceText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(.top, 4)

            Text(
                "Serás redirigido a nuestro WhatsApp de administración para completar tu pago de forma segura y activar tu membresía."
            )
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(.horizontal, 22)
            .padding(.top, 20)

            Button {
                openWhatsApp()
            } label: {
                HStack(spacing: 8) {
                    Text("CONTINUAR")

                    Image(systemName: "bolt.fill")
                }
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    Color("BeastTabSelected")
                )
                .clipShape(
                    Capsule()
                )
            }
            .padding(.top, 24)

            Button {
                onDismiss()
            } label: {
                Text("CANCELAR")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
        .padding(.bottom, 12)
        .background(
            Color("BeastBackground")
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 30,
                style: .continuous
            )
        )
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(
                    Color("BeastTabSelected")
                        .opacity(0.12)
                )
                .frame(
                    width: 58,
                    height: 58
                )

            Image(systemName: "creditcard.fill")
                .font(.system(size: 24))
                .foregroundStyle(
                    Color("BeastTabSelected")
                )
        }
    }

    private var priceText: String {
        let price = package.precioDescuento > 0
            ? package.precioDescuento
            : package.precioRegular

        return "$\(Int(price)).00"
    }

    private func openWhatsApp() {
        let administrationPhone = "523323542375"

        let message = """
        Hola, quiero adquirir el paquete \(package.name).

        Cliente: \(userName)
        Teléfono: \(phone)
        Paquete: \(package.name)
        Precio: \(priceText)
        """

        guard
            let encodedMessage = message.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(
                string:
                    "https://api.whatsapp.com/send?phone=\(administrationPhone)&text=\(encodedMessage)"
            )
        else {
            return
        }

        openURL(url)
    }
}
