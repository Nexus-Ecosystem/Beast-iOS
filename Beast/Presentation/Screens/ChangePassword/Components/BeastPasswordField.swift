import SwiftUI

struct BeastPasswordField: View {
    let title: String

    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
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

            HStack(
                spacing: 12
            ) {
                Group {
                    if isVisible {
                        TextField(
                            "",
                            text: $text,
                            prompt:
                                Text("••••••••")
                                .foregroundStyle(
                                    Color.gray.opacity(0.7)
                                )
                        )
                    } else {
                        SecureField(
                            "",
                            text: $text,
                            prompt:
                                Text("••••••••")
                                .foregroundStyle(
                                    Color.gray.opacity(0.7)
                                )
                        )
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(Color.black)
                .font(
                    .system(
                        size: 15,
                        weight: .medium
                    )
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
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color.gray
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .frame(height: 48)
            .background(
                Capsule()
                    .fill(Color.white)
            )
        }
    }
}
