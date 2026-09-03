import SwiftUI

struct LoginPasswordField: View {
    let title: String
    let placeholder: String

    @Binding var password: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(BeastColors.primary)
                .tracking(1.2)
                .padding(.leading, 12)

            HStack(spacing: 10) {
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text(placeholder)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(BeastColors.inputPlaceholder)
                    }

                    Group {
                        if isVisible {
                            TextField("", text: $password)
                        } else {
                            SecureField("", text: $password)
                        }
                    }
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(BeastColors.inputText)
                    .tint(BeastColors.primary)
                }

                Button {
                    isVisible.toggle()
                } label: {
                    Image(
                        systemName: isVisible
                            ? "eye.fill"
                            : "eye.slash.fill"
                    )
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.50))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .frame(height: 48)
            .background(BeastColors.loginInputBackground)
            .clipShape(Capsule())
        }
    }
}
