import SwiftUI

enum ProfileOptionStyle {
    case normal
    case danger
}

struct ProfileOptionRowView: View {

    let icon: String
    let title: String
    let trailing: String?
    let showChevron: Bool
    var style: ProfileOptionStyle = .normal

    private var rowColor: Color {
        style == .danger ? BeastProfileColors.danger : BeastProfileColors.accent
    }

    var body: some View {
        HStack(spacing: 15) {
            iconBubble

            Text(title)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(style == .danger ? BeastProfileColors.danger : BeastProfileColors.textPrimary)

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(title == "Versión" ? BeastProfileColors.accent : BeastProfileColors.textSecondary)
            }

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(style == .danger ? BeastProfileColors.danger : BeastProfileColors.textSecondary)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 62)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(rowColor.opacity(style == .danger ? 0.20 : 0.35), lineWidth: 1)
        }
    }

    private var iconBubble: some View {
        ZStack {
            Circle()
                .fill(rowColor.opacity(0.14))
                .frame(width: 34, height: 34)

            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(rowColor)
        }
    }
}
