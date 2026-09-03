import SwiftUI

struct ProfileSubscriptionCardView: View {

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(BeastProfileColors.accent.opacity(0.14))
                    .frame(width: 48, height: 48)

                Image(systemName: "crown.fill")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(BeastProfileColors.accent)
            }

            VStack(spacing: 5) {
                Text("Sin suscripción activa")
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundStyle(BeastProfileColors.textPrimary)

                Text("Activa un paquete para desbloquear más funciones.")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(BeastProfileColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {

            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                    Text("Adquirir paquete")
                }
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .frame(height: 44)
                .background(BeastProfileColors.accent)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(BeastProfileColors.border.opacity(0.55), lineWidth: 1)
        }
    }
}
