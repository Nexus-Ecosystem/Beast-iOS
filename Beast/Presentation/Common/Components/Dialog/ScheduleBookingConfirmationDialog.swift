import SwiftUI

struct ScheduleBookingConfirmationDialog: View {
    let item: ClassItem
    let date: Date

    var title: String = "CONFIRMAR RESERVA"
    var message: String =
        "Asegura tu lugar confirmando esta reserva, no te quedes sin tu lugar !."
    var confirmTitle: String = "CONFIRMAR"
    var destructive: Bool = false

    let onConfirm: () -> Void
    let onClose: () -> Void

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
        ZStack {
            Color.black
                .opacity(0.72)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iconView

                Text(title)
                    .font(
                        .system(
                            size: 19,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(
                        .center
                    )
                    .padding(
                        .top,
                        18
                    )

                Text(message)
                    .font(
                        .system(
                            size: 10
                        )
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(
                        .center
                    )
                    .lineSpacing(3)
                    .padding(
                        .horizontal,
                        22
                    )
                    .padding(
                        .top,
                        8
                    )

                reservationInfo
                    .padding(
                        .top,
                        20
                    )

                Button {
                    onConfirm()
                } label: {
                    Text(confirmTitle)
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            .white
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                        .frame(
                            height: 42
                        )
                        .background(
                            destructive
                            ? Color.red
                            : purple
                        )
                        .clipShape(
                            Capsule()
                        )
                }
                .buttonStyle(.plain)
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    20
                )

                Button {
                    onClose()
                } label: {
                    Text("CERRAR")
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            .white
                        )
                        .frame(
                            maxWidth:
                                .infinity
                        )
                        .frame(
                            height: 42
                        )
                        .background(
                            Color(
                                red: 0.15,
                                green: 0.17,
                                blue: 0.20
                            )
                        )
                        .clipShape(
                            Capsule()
                        )
                }
                .buttonStyle(.plain)
                .padding(
                    .horizontal,
                    18
                )
                .padding(
                    .top,
                    10
                )
                .padding(
                    .bottom,
                    18
                )
            }
            .frame(
                maxWidth: 276
            )
            .background(
                Color(
                    .systemBackground
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 26,
                    style: .continuous
                )
            )
            .shadow(
                color:
                    .black
                    .opacity(0.35),
                radius: 20,
                x: 0,
                y: 12
            )
        }
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    destructive
                    ? Color.red
                    : Color(
                        red: 0.20,
                        green: 0.29,
                        blue: 0.0
                    )
                )
                .frame(
                    width: 48,
                    height: 48
                )

            Image(
                systemName:
                    destructive
                    ? "xmark"
                    : "calendar.badge.checkmark"
            )
            .font(
                .system(
                    size: 21,
                    weight: .bold
                )
            )
            .foregroundStyle(
                destructive
                ? Color.white
                : neon
            )
        }
        .padding(
            .top,
            18
        )
    }

    private var reservationInfo: some View {
        VStack(spacing: 0) {
            HStack(
                spacing: 16
            ) {
                infoItem(
                    title: "Tipo Clase",
                    value: item.name,
                    highlightTitle: true
                )

                infoItem(
                    title: "COACH",
                    value: item.coach,
                    highlightTitle: false
                )
            }

            Divider()
                .padding(
                    .vertical,
                    12
                )

            HStack(
                spacing: 16
            ) {
                infoItem(
                    title: "Fecha",
                    value:
                        date
                        .scheduleDay,
                    highlightTitle: false
                )

                infoItem(
                    title: "Horario",
                    value: item.time,
                    highlightTitle: false
                )
            }
        }
        .padding(16)
        .background(
            Color(
                .secondarySystemBackground
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
        .padding(
            .horizontal,
            18
        )
    }

    private func infoItem(
        title: String,
        value: String,
        highlightTitle: Bool
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(title)
                .font(
                    .system(
                        size: 8,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    highlightTitle
                    ? purple
                    : .secondary
                )

            Text(value)
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    .primary
                )
                .lineLimit(1)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}
