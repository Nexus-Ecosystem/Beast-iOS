import SwiftUI

struct HistoryReservationCard: View {
    let reservation: ClassItemEntity

    var body: some View {
        HStack(
            spacing: 14
        ) {
            coachImage

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(
                    reservation.name
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .lineLimit(1)

                Text(
                    "\(reservation.diaAgendado)\n• Coach \(reservation.coach)"
                )
                .font(
                    .system(
                        size: 11
                    )
                )
                .foregroundStyle(
                    .secondary
                )
                .lineLimit(2)
            }

            Spacer()

            VStack(
                alignment: .trailing,
                spacing: 6
            ) {
                Text(
                    reservation.cancelled
                    ? "Cancelada"
                    : "Tomada"
                )
                .font(
                    .system(
                        size: 9,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    reservation.cancelled
                    ? Color.white
                    : Color.black
                )
                .padding(
                    .horizontal,
                    10
                )
                .padding(
                    .vertical,
                    5
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .fill(
                        reservation.cancelled
                        ? Color.red
                        : Color.green
                    )
                )

                Text(
                    reservation.time
                )
                .font(
                    .system(
                        size: 15,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    .secondary
                )
            }
        }
        .padding(
            .horizontal,
            18
        )
        .padding(
            .vertical,
            14
        )
        .background(
            RoundedRectangle(
                cornerRadius: 22
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
            width: 46,
            height: 46
        )
        .clipShape(
            Circle()
        )
    }

    private var initialsView: some View {
        ZStack {
            Circle()
                .fill(
                    Color.primary
                )

            Text(initials)
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color(
                        .systemBackground
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
}
