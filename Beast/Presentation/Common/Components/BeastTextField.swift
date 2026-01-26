import SwiftUI

struct BeastTextField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(Color("BeastTextSecondary"))
                .frame(width: 18)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(Color("BeastTextPrimary"))
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
