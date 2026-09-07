import SwiftUI

struct SignUpPasswordSecurityCard: View {
    let score: Int

    let hasUppercase: Bool
    let hasNumber: Bool
    let hasSpecialCharacter: Bool
    let hasMinLength: Bool

    private var strengthText:
        String
    {
        switch score {
        case 0, 1:
            return "DÉBIL"

        case 2, 3:
            return "MEDIA"

        case 4:
            return "FUERTE"

        default:
            return ""
        }
    }

    private var strengthColor:
        Color
    {
        switch score {
        case 0, 1:
            return BeastColors.danger

        case 2, 3:
            return .orange

        case 4:
            return BeastColors.primary

        default:
            return BeastColors.textSecondary
        }
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            HStack {
                Text(
                    "SEGURIDAD DE CONTRASEÑA"
                )
                .font(
                    .system(
                        size: 10,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )

                Spacer()

                Text(
                    strengthText
                )
                .font(
                    .system(
                        size: 10,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    strengthColor
                )
            }

            HStack(
                spacing: 4
            ) {
                ForEach(
                    0..<4,
                    id: \.self
                ) { index in
                    Capsule()
                        .fill(
                            index < score
                                ? BeastColors.primary
                                : BeastColors.border
                        )
                        .frame(height: 4)
                }
            }

            HStack {
                VStack(
                    spacing: 10
                ) {
                    rule(
                        "1 MAYÚSCULA",
                        completed:
                            hasUppercase
                    )

                    rule(
                        "1 CARÁCTER ESPECIAL",
                        completed:
                            hasSpecialCharacter
                    )
                }

                VStack(
                    spacing: 10
                ) {
                    rule(
                        "1 NÚMERO",
                        completed:
                            hasNumber
                    )

                    rule(
                        "8+ CARACTERES",
                        completed:
                            hasMinLength
                    )
                }
            }
        }
        .padding(20)
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

    private func rule(
        _ title: String,
        completed: Bool
    ) -> some View {
        HStack(
            spacing: 6
        ) {
            Image(
                systemName:
                    completed
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(
                .system(
                    size: 12,
                    weight: .bold
                )
            )

            Text(title)
                .font(
                    .system(
                        size: 8,
                        weight: .bold
                    )
                )

            Spacer()
        }
        .foregroundStyle(
            completed
                ? BeastColors.primary
                : BeastColors.textSecondary
        )
        .frame(
            maxWidth: .infinity
        )
    }
}
