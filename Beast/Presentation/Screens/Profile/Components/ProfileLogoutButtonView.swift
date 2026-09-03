import SwiftUI

struct ProfileLogoutButtonView: View {

    var body: some View {
        Button {

        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 15, weight: .heavy))

                Text("Cerrar sesión")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(BeastProfileColors.danger)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(BeastProfileColors.danger.opacity(0.18), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}
