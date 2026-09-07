import SwiftUI

struct ScheduleEmptyStateView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(
                    cornerRadius: 22
                )
                .fill(
                    BeastColors.surface
                )

                Image(
                    systemName: "clock"
                )
                .font(
                    .system(
                        size: 36,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    BeastColors.yellowPrimary
                )
            }
            .frame(
                width: 78,
                height: 78
            )

            HStack(spacing: 6) {
                Text("INTENTA CON OTRAS FECHAS")
                    .font(
                        .system(
                            size: 9,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Image(
                    systemName: "calendar"
                )
                .font(
                    .system(
                        size: 9,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }
            .padding(.top, 25)

            Text("SIN CLASES")
                .font(
                    .system(
                        size: 27,
                        weight: .black
                    )
                    .italic()
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .padding(.top, 24)

            Text("DISPONIBLES")
                .font(
                    .system(
                        size: 27,
                        weight: .black
                    )
                    .italic()
                )
                .foregroundStyle(
                    BeastColors.primary
                )

            Text(
                "Parece que no hay clases programadas para esta fecha. ¡Prueba buscando en otro día o en una sucursal cercana!"
            )
            .font(
                .system(size: 13)
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.horizontal, 40)
            .padding(.top, 14)
        }
        .frame(maxWidth: .infinity)
    }
}
