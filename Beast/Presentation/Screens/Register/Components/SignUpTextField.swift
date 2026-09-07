import SwiftUI

struct SignUpTextField: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let title: String
    let placeholder: String

    @Binding var text: String

    var keyboardType:
        UIKeyboardType = .default

    private var fieldBackground:
        Color
    {
        colorScheme == .dark
            ? Color.white
            : BeastColors.loginInputBackground
    }

    private var fieldText:
        Color
    {
        colorScheme == .dark
            ? Color.black
            : Color.white
    }

    private var placeholderColor:
        Color
    {
        colorScheme == .dark
            ? Color.gray
            : BeastColors.inputPlaceholder
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(title)
                .font(
                    .system(
                        size: 10,
                        weight: .black
                    )
                )
                .tracking(1)
                .foregroundStyle(
                    BeastColors.primary
                )
                .padding(
                    .leading,
                    12
                )

            ZStack(
                alignment: .leading
            ) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(
                            .system(
                                size: 14
                            )
                        )
                        .foregroundStyle(
                            placeholderColor
                        )
                        .padding(
                            .horizontal,
                            18
                        )
                }

                TextField(
                    "",
                    text: $text
                )
                .keyboardType(
                    keyboardType
                )
                .textInputAutocapitalization(
                    keyboardType == .emailAddress
                        ? .never
                        : .words
                )
                .autocorrectionDisabled()
                .font(
                    .system(
                        size: 14
                    )
                )
                .foregroundStyle(
                    fieldText
                )
                .tint(
                    BeastColors.primary
                )
                .padding(
                    .horizontal,
                    18
                )
            }
            .frame(height: 50)
            .background(
                fieldBackground
            )
            .clipShape(
                Capsule()
            )
        }
    }
}
