import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isEnabled ? Color("BeastYellowPrimary") : Color("BeastBorder"))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.75)
    }
}
