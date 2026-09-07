import SwiftUI

struct EditProfileField: View {
    let title: String

    @Binding var text: String

    var keyboardType:
        UIKeyboardType = .default

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(
                title
            )
            .font(
                .system(
                    size: 9,
                    weight: .black
                )
            )
            .tracking(1)
            .foregroundStyle(
                BeastColors.primary
            )
            .padding(
                .leading,
                8
            )

            TextField(
                "",
                text: $text
            )
            .keyboardType(
                keyboardType
            )
            .textInputAutocapitalization(
                keyboardType == .phonePad
                ? .never
                : .words
            )
            .font(
                .system(
                    size: 13,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .padding(
                .horizontal,
                20
            )
            .frame(
                height: 52
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 22
                )
                .fill(
                    BeastColors.surface
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 22
                )
                .stroke(
                    BeastColors.border,
                    lineWidth: 1
                )
            )
        }
    }
}
