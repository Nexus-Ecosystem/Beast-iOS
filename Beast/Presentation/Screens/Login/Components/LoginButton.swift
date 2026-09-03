import SwiftUI

struct LoginButton: View {
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button {
            guard isEnabled, !isLoading else { return }
            action()
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(BeastColors.buttonText)
                } else {
                    Text("ENTRAR")
                        .font(.system(size: 13, weight: .black))
                        .italic()

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .foregroundStyle(
                isEnabled
                    ? BeastColors.buttonText
                    : Color.gray
            )
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                BeastColors.primary.opacity(
                    isEnabled ? 1 : 0.28
                )
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isLoading)
    }
}
