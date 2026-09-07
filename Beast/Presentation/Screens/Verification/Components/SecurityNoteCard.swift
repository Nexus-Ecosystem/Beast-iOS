import SwiftUI

struct SecurityNoteCard: View {
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 14
        ) {
            Image(
                systemName:
                    "info.circle.fill"
            )
            .font(
                .system(
                    size: 17
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .frame(
                width: 32,
                height: 32
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                )
                .fill(
                    BeastColors.background
                )
            )

            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                Text(
                    "NOTA DE SEGURIDAD"
                )
                .font(
                    .system(
                        size: 11,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )

                Text(
                    "El código expirará en 10 minutos. Por favor, no compartas este código con nadie. El equipo de soporte nunca te lo pedirá."
                )
                .font(
                    .system(
                        size: 11
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .lineSpacing(3)
            }
        }
        .padding(18)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .fill(
                BeastColors.surface
            )
        )
    }
}
