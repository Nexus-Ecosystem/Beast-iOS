import SwiftUI

struct LoginTextField: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let title: String
    let placeholder: String

    @Binding var text: String

    private var fieldBackground: Color {
        colorScheme == .dark
            ? Color.white
            : BeastColors.loginInputBackground
    }

    private var fieldText: Color {
        colorScheme == .dark
            ? Color.black
            : BeastColors.inputText
    }

    private var placeholderColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.48)
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
                .foregroundStyle(
                    BeastColors.primary
                )
                .tracking(1.2)
                .padding(.leading, 12)

            ZStack(
                alignment: .leading
            ) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(
                            .system(
                                size: 16,
                                weight: .regular
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
                .font(
                    .system(
                        size: 16,
                        weight: .regular
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
            .frame(height: 48)
            .background(
                fieldBackground
            )
            .clipShape(
                Capsule()
            )
        }
    }
}
