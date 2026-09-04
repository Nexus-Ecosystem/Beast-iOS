import SwiftUI

struct UpcomingReservationCard: View {
    let reservation: ClassItemEntity

    private let purple = Color(
        red: 0.46,
        green: 0.27,
        blue: 1.0
    )

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            HStack(
                alignment: .top
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 7
                ) {
                    Label {
                        Text(reservation.time)
                    } icon: {
                        Image(
                            systemName: "clock"
                        )
                    }
                    .font(
                        .system(
                            size: 18,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        purple
                    )

                    Text(
                        "COACH : \(reservation.coach)"
                    )
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        purple
                    )
                }

                Spacer()

                coachImage
            }

            Text("Tipo de clase")
                .font(
                    .system(
                        size: 12
                    )
                )
                .foregroundStyle(.secondary)

            Text(reservation.name)
                .font(
                    .system(
                        size: 27,
                        weight: .black
                    )
                )
                .italic()

            HStack(
                spacing: 12
            ) {
                detail(
                    icon: "calendar",
                    text: reservation.diaAgendado
                )

                detail(
                    icon: "mappin.and.ellipse",
                    text: reservation.sucursalAgendada
                )
            }

            Button {
            } label: {
                Text("VER DETALLE")
                    .font(
                        .system(
                            size: 11,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 42
                    )
                    .background(
                        Capsule()
                            .fill(purple)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(
            RoundedRectangle(
                cornerRadius: 28
            )
            .fill(
                Color(
                    .secondarySystemBackground
                )
            )
        )
    }

    private var coachImage: some View {
        Group {
            if
                !reservation.photo.isEmpty,
                let url = URL(
                    string: reservation.photo
                )
            {
                AsyncImage(
                    url: url
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    initialsView
                }
            } else {
                initialsView
            }
        }
        .frame(
            width: 48,
            height: 48
        )
        .clipShape(
            Circle()
        )
    }

    private var initialsView: some View {
        ZStack {
            Circle()
                .fill(
                    Color(
                        .tertiarySystemBackground
                    )
                )

            Text(initials)
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
        }
    }

    private var initials: String {
        String(
            reservation.coach
                .split(separator: " ")
                .prefix(2)
                .compactMap {
                    $0.first
                }
        )
        .uppercased()
    }

    private func detail(
        icon: String,
        text: String
    ) -> some View {
        HStack(
            spacing: 6
        ) {
            Image(
                systemName: icon
            )
            .foregroundStyle(
                purple
            )

            Text(text)
                .lineLimit(1)
        }
        .font(
            .system(
                size: 9,
                weight: .medium
            )
        )
    }
}
