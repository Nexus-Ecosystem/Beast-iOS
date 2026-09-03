import SwiftUI

struct ProfileAvatarView: View {

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 96, height: 96)
                    .overlay {
                        Circle()
                            .stroke(BeastProfileColors.accent, lineWidth: 2)
                    }
                    .shadow(
                        color: BeastProfileColors.accent.opacity(0.18),
                        radius: 18,
                        x: 0,
                        y: 10
                    )

                Image(systemName: "person.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(BeastProfileColors.textSecondary)

                Button {

                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(BeastProfileColors.accent)
                        .clipShape(Circle())
                        .shadow(
                            color: BeastProfileColors.accent.opacity(0.35),
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                }
                .buttonStyle(.plain)
            }

            Text("Usuario Beast")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(BeastProfileColors.textPrimary)

            Text("Administra tu cuenta y suscripción")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(BeastProfileColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
