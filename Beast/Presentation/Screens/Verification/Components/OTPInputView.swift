import SwiftUI

struct OTPInputView: View {
    @Binding var otp: String

    let onChange: (String) -> Void

    @FocusState
    private var isFocused: Bool

    var body: some View {
        ZStack {
            TextField(
                "",
                text: $otp
            )
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .focused($isFocused)
            .opacity(0.01)
            .frame(height: 1)
            .onChange(of: otp) { _, value in
                onChange(value)
            }

            HStack(
                spacing: 10
            ) {
                ForEach(
                    0..<6,
                    id: \.self
                ) { index in
                    let value = character(
                        at: index
                    )

                    let active =
                        index == otp.count

                    Text(value)
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            BeastColors.textPrimary
                        )
                        .frame(
                            width: 48,
                            height: 48
                        )
                        .background(
                            Circle()
                                .fill(
                                    BeastColors.surface
                                )
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    active
                                        ? BeastColors.primary.opacity(0.75)
                                        : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .contentShape(
                Rectangle()
            )
            .onTapGesture {
                isFocused = true
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    private func character(
        at index: Int
    ) -> String {
        guard index < otp.count else {
            return ""
        }

        let stringIndex =
            otp.index(
                otp.startIndex,
                offsetBy: index
            )

        return String(
            otp[stringIndex]
        )
    }
}
