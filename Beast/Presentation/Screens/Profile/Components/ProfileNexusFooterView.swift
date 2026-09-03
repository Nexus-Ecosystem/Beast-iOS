import SwiftUI

struct ProfileNexusFooterView: View {

    var body: some View {
        HStack(spacing: 8) {
            Image("logo_nexus")
                .resizable()
                .scaledToFit()
                .frame(height: 16)
            
            Text("by")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(BeastProfileColors.textSecondary)

            Text("Nexus Ecosystem")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(BeastProfileColors.textSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(BeastProfileColors.border.opacity(0.35), lineWidth: 1)
        }
        .opacity(0.92)
    }
}
