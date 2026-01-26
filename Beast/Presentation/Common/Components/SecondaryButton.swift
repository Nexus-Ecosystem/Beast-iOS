import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(Color("BeastTextPrimary"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color("BeastBorder"), lineWidth: 1)
            )
        }
    }
}
