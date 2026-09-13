import SwiftUI

struct DeleteAccountConfirmationField: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ESCRIBE “ELIMINAR” PARA CONFIRMAR")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(BeastColors.textSecondary)

            TextField(
                "ELIMINAR",
                text: $text
            )
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled()
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(BeastColors.textPrimary)
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
                .fill(BeastColors.surface)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
                .stroke(
                    BeastColors.border,
                    lineWidth: 1
                )
            )
        }
    }
}
