import SwiftUI

struct LoginPasswordField: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let title: String
    let placeholder: String

    @Binding var password: String
    @Binding var isVisible: Bool

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

    private var iconColor: Color {
        colorScheme == .dark
            ? Color.gray
            : Color.white.opacity(0.50)
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

            HStack(
                spacing: 10
            ) {
                ZStack(
                    alignment: .leading
                ) {
                    if password.isEmpty {
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
                    }

                    Group {
                        if isVisible {
                            TextField(
                                "",
                                text: $password
                            )
                        } else {
                            SecureField(
                                "",
                                text: $password
                            )
                        }
                    }
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
                    .textInputAutocapitalization(
                        .never
                    )
                    .autocorrectionDisabled()
                }

                Button {
                    isVisible.toggle()
                } label: {
                    Image(
                        systemName:
                            isVisible
                            ? "eye.fill"
                            : "eye.slash.fill"
                    )
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        iconColor
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(
                .horizontal,
                18
            )
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
