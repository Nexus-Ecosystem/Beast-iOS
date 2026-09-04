import SwiftUI

struct ScheduleClassCard: View {
    let item: ClassItem
    let isExtraBooking: Bool
    let canCancel: Bool
    let onAction: () -> Void
    let onSelectBike: () -> Void

    private let purple = Color(
        red: 0.46,
        green: 0.27,
        blue: 1.0
    )

    private let darkButton = Color(
        red: 0.15,
        green: 0.17,
        blue: 0.20
    )

    var body: some View {
        VStack(spacing: 18) {
            HStack(
                alignment: .top,
                spacing: 12
            ) {
                coachImage

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(item.name)
                        .font(
                            .system(
                                size: 16,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            isDimmed
                            ? Color.secondary
                            : Color.primary
                        )

                    Text("Maestr@: \(item.coach)")
                        .font(
                            .system(
                                size: 11,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(.secondary)
                }

                Spacer()

                statusBadge
            }

            HStack(spacing: 18) {
                Label {
                    Text(item.time)
                } icon: {
                    Image(
                        systemName: "calendar"
                    )
                }

                Label {
                    Text(
                        "Beast Spinning Tesistan"
                    )
                } icon: {
                    Image(
                        systemName: difficultyIcon
                    )
                }
            }
            .font(
                .system(
                    size: 10,
                    weight: .regular
                )
            )
            .foregroundStyle(.secondary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )

            capacityView

            Button(
                action: onAction
            ) {
                Text(actionTitle)
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        actionTextColor
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 40
                    )
                    .background(
                        Capsule()
                            .fill(
                                actionButtonColor
                            )
                    )
            }
            .buttonStyle(.plain)
            .disabled(!actionEnabled)

            if item.isScheduled {
                Button(
                    action: onSelectBike
                ) {
                    Text("Seleccionar bici")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(
                            height: 40
                        )
                        .background(
                            Capsule()
                                .fill(purple)
                        )
                }
                .buttonStyle(.plain)

                Text(
                    "LAS CANCELACIONES SE DEBE HACER 2 HORAS ANTES DE LA CLASE"
                )
                .font(
                    .system(
                        size: 7,
                        weight: .regular
                    )
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(
                    maxWidth: .infinity
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(
                cornerRadius: 24
            )
            .fill(
                Color(
                    .secondarySystemBackground
                )
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 24
            )
            .stroke(
                LinearGradient(
                    stops: [
                        .init(
                            color: difficultyColor,
                            location: 0.00
                        ),
                        .init(
                            color: difficultyColor.opacity(
                                0.75
                            ),
                            location: 0.10
                        ),
                        .init(
                            color: difficultyColor.opacity(
                                0.20
                            ),
                            location: 0.22
                        ),
                        .init(
                            color: .clear,
                            location: 0.30
                        ),
                        .init(
                            color: .clear,
                            location: 1.00
                        )
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 1.2
            )
        )
        .opacity(
            isDimmed
            ? 0.65
            : 1
        )
    }

    private var capacityView: some View {
        VStack(spacing: 8) {
            HStack {
                Text(
                    isFull
                    ? "Clase llena"
                    : "Capacidad"
                )

                Spacer()

                Text(
                    "\(item.agenda)/\(item.total) disponibles"
                )
            }
            .font(
                .system(
                    size: 9,
                    weight: .regular
                )
            )
            .foregroundStyle(.secondary)

            GeometryReader { proxy in
                ZStack(
                    alignment: .leading
                ) {
                    Capsule()
                        .fill(
                            darkButton
                        )
                        .frame(
                            height: 3
                        )

                    Capsule()
                        .fill(
                            capacityColor
                        )
                        .frame(
                            width:
                                proxy.size.width *
                                capacityProgress,
                            height: 3
                        )
                }
            }
            .frame(
                height: 3
            )
        }
    }

    private var coachImage: some View {
        Group {
            if
                !item.photo.isEmpty,
                let url = URL(
                    string: item.photo
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
            width: 40,
            height: 40
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
                        red: 0.13,
                        green: 0.13,
                        blue: 0.15
                    )
                )

            Text(initials)
                .font(
                    .system(
                        size: 9,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
        }
    }

    private var initials: String {
        String(
            item.coach
                .split(
                    separator: " "
                )
                .prefix(2)
                .compactMap {
                    $0.first
                }
        )
        .uppercased()
    }

    private var statusBadge: some View {
        Text(statusBadgeTitle)
            .font(
                .system(
                    size: 8,
                    weight: .bold
                )
            )
            .foregroundStyle(
                difficultyColor
            )
            .padding(
                .horizontal,
                8
            )
            .padding(
                .vertical,
                5
            )
            .background(
                Capsule()
                    .fill(
                        difficultyColor.opacity(
                            0.12
                        )
                    )
            )
            .overlay(
                Capsule()
                    .stroke(
                        difficultyColor.opacity(
                            0.55
                        ),
                        lineWidth: 0.7
                    )
            )
    }

    private var statusBadgeTitle: String {
        if item.isScheduled {
            if item.cancelled {
                return "Clase cancelada"
            }

            return "Agendada"
        }

        return difficultyText
    }

    private var difficultyText: String {
        switch item.level {
        case 1:
            return "Fácil"

        case 2:
            return "Media"

        case 3:
            return "Retadora"

        case 4:
            return "Difícil"

        default:
            return "Fácil"
        }
    }

    private var difficultyIcon: String {
        switch item.level {
        case 1:
            return "figure.mind.and.body"

        case 2:
            return "dumbbell.fill"

        case 3:
            return "figure.indoor.cycle"

        case 4:
            return "bolt.fill"

        default:
            return "figure.mind.and.body"
        }
    }

    private var difficultyColor: Color {
        switch item.level {
        case 1:
            return Color(
                red: 0.035,
                green: 0.612,
                blue: 0.020
            )

        case 2:
            return Color(
                red: 0.353,
                green: 0.310,
                blue: 0.812
            )

        case 3:
            return Color(
                red: 0.878,
                green: 0.478,
                blue: 0.145
            )

        case 4:
            return Color(
                red: 0.878,
                green: 0.145,
                blue: 0.145
            )

        default:
            return Color(
                red: 0.035,
                green: 0.612,
                blue: 0.020
            )
        }
    }

    private var capacityProgress: CGFloat {
        guard item.total > 0 else {
            return 0
        }

        return min(
            CGFloat(item.agenda) /
            CGFloat(item.total),
            1
        )
    }

    private var capacityColor: Color {
        if item.isScheduled {
            return darkButton
        }

        return purple
    }

    private var isFull: Bool {
        item.total > 0 &&
        item.agenda >= item.total
    }

    private var isDimmed: Bool {
        item.cancelled ||
        isFull
    }

    private var actionTitle: String {
        if item.isScheduled {
            if item.cancelled {
                return "CLASE CANCELADA"
            }

            if canCancel {
                return "CANCELAR RESERVA"
            }

            return "ESPERANDO ASISTENCIA"
        }

        if item.cancelled {
            return "CLASE CANCELADA"
        }

        if isFull {
            return "HORARIO LLENO"
        }

        if isExtraBooking {
            return "AGENDA EXTRA"
        }

        return "AGENDAR"
    }

    private var actionEnabled: Bool {
        if item.cancelled {
            return false
        }

        if isFull {
            return false
        }

        if item.isScheduled &&
            !canCancel
        {
            return false
        }

        return true
    }

    private var actionButtonColor: Color {
        if item.isScheduled {
            if item.cancelled {
                return darkButton.opacity(
                    0.50
                )
            }

            if canCancel {
                return darkButton
            }

            return Color(
                .secondarySystemBackground
            )
        }

        if item.cancelled {
            return darkButton.opacity(
                0.50
            )
        }

        if isFull {
            return purple
        }

        return purple
    }

    private var actionTextColor: Color {
        if item.isScheduled {
            if canCancel {
                return .white
            }

            return .secondary
        }

        if isFull {
            return .secondary
        }

        return .white
    }
}
