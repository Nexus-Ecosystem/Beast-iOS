import SwiftUI

struct BeastSecureField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String

    @State private var isRevealed: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(Color("BeastTextSecondary"))
                .frame(width: 18)

            Group {
                if isRevealed {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .foregroundStyle(Color("BeastTextPrimary"))

            Button {
                isRevealed.toggle()
            } label: {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
                    .foregroundStyle(Color("BeastTextSecondary"))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color("BeastSurface"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color("BeastBorder"), lineWidth: 1)
        )
    }
}
