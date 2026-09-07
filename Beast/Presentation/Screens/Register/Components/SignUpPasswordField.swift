import SwiftUI

struct SignUpPasswordField: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let title: String

    @Binding var password: String
    @Binding var isVisible: Bool

    private var background:
        Color
    {
        colorScheme == .dark
            ? Color.white
            : BeastColors.loginInputBackground
    }

    private var textColor:
        Color
    {
        colorScheme == .dark
            ? Color.black
            : Color.white
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

            HStack(
                spacing: 10
            ) {
                Group {
                    if isVisible {
                        TextField(
                            "",
                            text: $password,
                            prompt:
                                Text("••••••••")
                                .foregroundStyle(
                                    Color.gray
                                )
                        )
                    } else {
                        SecureField(
                            "",
                            text: $password,
                            prompt:
                                Text("••••••••")
                                .foregroundStyle(
                                    Color.gray
                                )
                        )
                    }
                }
                .textInputAutocapitalization(
                    .never
                )
                .autocorrectionDisabled()
                .foregroundStyle(
                    textColor
                )
                .tint(
                    BeastColors.primary
                )

                Button {
                    isVisible.toggle()
                } label: {
                    Image(
                        systemName:
                            isVisible
                            ? "eye.fill"
                            : "eye.slash.fill"
                    )
                    .foregroundStyle(
                        Color.gray
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(
                .horizontal,
                18
            )
            .frame(height: 50)
            .background(
                background
            )
            .clipShape(
                Capsule()
            )
        }
    }
}
