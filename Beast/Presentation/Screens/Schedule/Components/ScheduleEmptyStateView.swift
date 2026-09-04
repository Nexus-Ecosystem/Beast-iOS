import SwiftUI

struct ScheduleEmptyStateView: View {
    private let purple = Color(
        red: 0.46,
        green: 0.27,
        blue: 1.0
    )

    private let neon = Color(
        red: 0.76,
        green: 1.0,
        blue: 0.0
    )

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(
                    cornerRadius: 22
                )
                .fill(Color.primary.opacity(0.85))

                Image(
                    systemName: "clock"
                )
                .font(
                    .system(
                        size: 36,
                        weight: .regular
                    )
                )
                .foregroundStyle(neon)
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
                    .foregroundStyle(.primary)

                Image(
                    systemName: "calendar"
                )
                .font(
                    .system(
                        size: 9,
                        weight: .bold
                    )
                )
                .foregroundStyle(purple)
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
                .foregroundStyle(.primary)
                .padding(.top, 24)

            Text("DISPONIBLES")
                .font(
                    .system(
                        size: 27,
                        weight: .black
                    )
                    .italic()
                )
                .foregroundStyle(purple)

            Text(
                "Parece que no hay clases programadas para esta fecha. ¡Prueba buscando en otro día o en una sucursal cercana!"
            )
            .font(
                .system(size: 13)
            )
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.horizontal, 40)
            .padding(.top, 14)
        }
        .frame(maxWidth: .infinity)
    }
}
