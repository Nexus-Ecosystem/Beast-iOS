import SwiftUI

struct NotificationCard: View {
    let notification:
        NotificationModel

    var body: some View {
        HStack(
            alignment: .top,
            spacing: 14
        ) {
            icon

            VStack(
                alignment: .leading,
                spacing: 9
            ) {
                HStack(
                    alignment: .top
                ) {
                    Text(
                        notification.title
                    )
                    .font(
                        .system(
                            size: 15,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                    Spacer()

                    if !notification.read {
                        Circle()
                            .fill(
                                BeastColors.primary
                            )
                            .frame(
                                width: 7,
                                height: 7
                            )
                            .padding(
                                .top,
                                5
                            )
                    }
                }

                Text(
                    notification.body
                )
                .font(
                    .system(
                        size: 12
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .lineSpacing(
                    3
                )

                if !formattedTimestamp.isEmpty {
                    Text(
                        formattedTimestamp
                    )
                    .font(
                        .system(
                            size: 9,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                            .opacity(
                                0.6
                            )
                    )
                }
            }
        }
        .padding(
            18
        )
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(
                BeastColors.surface
            )
        )
        .overlay {
            if notification.type == 1 {
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .stroke(
                    BeastColors.primary,
                    lineWidth: 1.5
                )
            }
        }
    }

    private var icon:
        some View
    {
        ZStack {
            Circle()
                .fill(
                    BeastColors.textPrimary
                )

            Image(
                systemName:
                    iconName
            )
            .font(
                .system(
                    size: 13,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.background
            )
        }
        .frame(
            width: 32,
            height: 32
        )
    }

    private var iconName:
        String
    {
        switch notification.type {
        case 1:
            return "creditcard.fill"

        case 2:
            return "calendar"

        case 3:
            return "megaphone.fill"

        case 4:
            return "star.fill"

        case 5:
            return "bell.fill"

        default:
            return "bell.fill"
        }
    }

    private var formattedTimestamp:
        String
    {
        let value =
            notification.timestamp
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard !value.isEmpty else {
            return ""
        }

        if let date =
            Self.isoWithFraction
                .date(
                    from: value
                )
        {
            return Self.outputFormatter
                .string(
                    from: date
                )
        }

        if let date =
            Self.isoFormatter
                .date(
                    from: value
                )
        {
            return Self.outputFormatter
                .string(
                    from: date
                )
        }

        return value
    }

    private static let isoWithFraction:
        ISO8601DateFormatter =
    {
        let formatter =
            ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        return formatter
    }()

    private static let isoFormatter:
        ISO8601DateFormatter =
    {
        ISO8601DateFormatter()
    }()

    private static let outputFormatter:
        DateFormatter =
    {
        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier:
                    "es_MX"
            )

        formatter.dateFormat =
            "d MMM · HH:mm"

        return formatter
    }()
}
