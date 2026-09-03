import SwiftUI

struct UpcomingClassCard: View {
    let reservation: ClassItemEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Clases Agendadas")
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

            HStack(
                alignment: .bottom
            ) {
                Text("Próxima")
                    .font(
                        .system(
                            size: 32,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Spacer()

                Text("1 clase hoy")
                    .font(
                        .system(
                            size: 12,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .padding(.bottom, 6)
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack(
                    alignment: .top
                ) {
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        HStack(spacing: 6) {
                            Image(
                                systemName: "clock.fill"
                            )
                            .font(
                                .system(
                                    size: 16,
                                    weight: .bold
                                )
                            )

                            Text(
                                reservation.time
                            )
                            .font(
                                .system(
                                    size: 20,
                                    weight: .bold
                                )
                            )
                        }
                        .foregroundStyle(
                            BeastColors.primary
                        )

                        Text(
                            "COACH : \(reservation.coach)"
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .black
                            )
                        )
                        .foregroundStyle(
                            BeastColors.primary
                        )
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(
                                Color.black.opacity(0.85)
                            )
                            .frame(
                                width: 48,
                                height: 48
                            )

                        Image(
                            systemName: "person.fill"
                        )
                        .foregroundStyle(
                            BeastColors.textSecondary
                        )
                    }
                }

                Text("Tipo de clase")
                    .font(
                        .system(
                            size: 14
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .padding(.top, 12)

                Text(
                    reservation.name
                )
                .font(
                    .system(
                        size: 30,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .padding(.top, 4)

                HStack(spacing: 8) {
                    HomeDetailChip(
                        icon: "calendar",
                        text: reservation.diaAgendado
                    )

                    HomeDetailChip(
                        icon: "mappin.and.ellipse",
                        text: reservation.sucursalAgendada
                    )
                }
                .padding(.top, 12)

                Button {
                } label: {
                    Text("VER DETALLE")
                        .font(
                            .system(
                                size: 12,
                                weight: .black
                            )
                        )
                        .foregroundStyle(
                            BeastColors.buttonText
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            BeastColors.primary
                        )
                        .clipShape(
                            Capsule()
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
            }
            .padding(24)
            .background(
                BeastColors.surface
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 32,
                    style: .continuous
                )
            )
            .padding(.top, 18)
        }
    }
}

private struct HomeDetailChip: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(
                systemName: icon
            )
            .font(
                .system(
                    size: 14,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(text)
                .font(
                    .system(
                        size: 10,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
        }
        .padding(
            .horizontal,
            10
        )
        .padding(
            .vertical,
            10
        )
        .background(
            BeastColors.surface
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
    }
}
