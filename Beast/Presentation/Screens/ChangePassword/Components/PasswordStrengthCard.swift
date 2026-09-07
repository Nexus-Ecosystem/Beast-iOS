import SwiftUI

struct PasswordStrengthCard: View {
    let progress: Double
    let percentage: Int

    let hasUppercase: Bool
    let hasNumber: Bool
    let hasSpecialCharacter: Bool
    let hasMinLength: Bool

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 18
        ) {
            HStack {
                Text("FORTALEZA")
                    .font(
                        .system(
                            size: 12,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Spacer()

                Text("\(percentage)%")
                    .font(
                        .system(
                            size: 13,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )
            }

            GeometryReader { geometry in
                ZStack(
                    alignment: .leading
                ) {
                    Capsule()
                        .fill(
                            Color.gray.opacity(0.28)
                        )

                    Capsule()
                        .fill(
                            BeastColors.primary
                        )
                        .frame(
                            width:
                                geometry.size.width *
                                progress
                        )
                        .animation(
                            .easeInOut(
                                duration: 0.25
                            ),
                            value: progress
                        )
                }
            }
            .frame(height: 6)

            VStack(
                spacing: 14
            ) {
                HStack(
                    spacing: 12
                ) {
                    PasswordRequirementItem(
                        title: "1 MAYÚSCULA",
                        isCompleted:
                            hasUppercase
                    )

                    PasswordRequirementItem(
                        title: "1 NÚMERO",
                        isCompleted:
                            hasNumber
                    )
                }

                HStack(
                    spacing: 12
                ) {
                    PasswordRequirementItem(
                        title:
                            "1 CARÁCTER ESPECIAL",
                        isCompleted:
                            hasSpecialCharacter
                    )

                    PasswordRequirementItem(
                        title: "8+ CARACTERES",
                        isCompleted:
                            hasMinLength
                    )
                }
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(
                BeastColors.surface
            )
        )
    }
}
