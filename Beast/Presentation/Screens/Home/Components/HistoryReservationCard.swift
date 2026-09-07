import SwiftUI

struct HistoryReservationCard: View {
    let reservation: ClassItemEntity

    var body: some View {
        HStack(spacing: 14) {
            coachImage

            VStack(alignment: .leading, spacing: 4) {
                Text(reservation.name)
                    .font(
                        .system(
                            size: 14,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
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
                    BeastColors.textSecondary
                )
                .lineLimit(2)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
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
                    : BeastColors.buttonText
                )
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .fill(
                        reservation.cancelled
                        ? BeastColors.danger
                        : BeastColors.success
                    )
                )

                Text(reservation.time)
                    .font(
                        .system(
                            size: 15,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(
                cornerRadius: 22
            )
            .fill(
                BeastColors.surface
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 22
            )
            .stroke(
                BeastColors.border,
                lineWidth: 1
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
                    BeastColors.primary
                )

            Text(initials)
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.buttonText
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
