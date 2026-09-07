import SwiftUI

struct LoginLegalFooter: View {
    var body: some View {
        VStack(
            spacing: 3
        ) {
            Text(
                "AL CONTINUAR CON EL USO DE LA APP ACEPTAS LOS"
            )
            .font(
                .system(
                    size: 8,
                    weight: .medium
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )

            Text(
                "TÉRMINOS DE SERVICIO & POLÍTICAS DE PRIVACIDAD"
            )
            .font(
                .system(
                    size: 8,
                    weight: .medium
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .underline()
        }
        .multilineTextAlignment(
            .center
        )
        .frame(
            maxWidth: .infinity
        )
    }
}
