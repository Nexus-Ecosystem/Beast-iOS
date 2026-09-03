import SwiftUI

struct ProfileDarkModeRowView: View {

    @Binding var isDarkMode: Bool

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(BeastProfileColors.accent.opacity(0.14))
                    .frame(width: 34, height: 34)

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(BeastProfileColors.accent)
            }

            Text("Modo oscuro")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(BeastProfileColors.textPrimary)

            Spacer()

            Toggle("", isOn: $isDarkMode)
                .labelsHidden()
                .tint(BeastProfileColors.accent)
        }
        .padding(.horizontal, 16)
        .frame(height: 66)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(BeastProfileColors.border.opacity(0.35), lineWidth: 1)
        }
    }
}
