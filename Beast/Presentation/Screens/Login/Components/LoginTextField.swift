import SwiftUI

struct LoginTextField: View {
    let title: String
    let placeholder: String

    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(BeastColors.primary)
                .tracking(1.2)
                .padding(.leading, 12)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(BeastColors.inputPlaceholder)
                        .padding(.horizontal, 18)
                }

                TextField("", text: $text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(BeastColors.inputText)
                    .tint(BeastColors.primary)
                    .padding(.horizontal, 18)
            }
            .frame(height: 48)
            .background(BeastColors.loginInputBackground)
            .clipShape(Capsule())
        }
    }
}
