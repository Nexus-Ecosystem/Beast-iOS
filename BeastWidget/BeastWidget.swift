import WidgetKit
import SwiftUI

// MARK: - Entry

struct BeastWidgetEntry: TimelineEntry {
    let date: Date
    let classDate: Date?
    let className: String?
    let coachName: String?
    let bikeNumber: Int?

    var hasUpcomingClass: Bool {
        classDate != nil &&
        className != nil &&
        coachName != nil
    }
}

// MARK: - Provider

struct BeastWidgetProvider: TimelineProvider {

    func placeholder(
        in context: Context
    ) -> BeastWidgetEntry {
        upcomingEntry()
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (BeastWidgetEntry) -> Void
    ) {
        completion(upcomingEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<BeastWidgetEntry>) -> Void
    ) {
        // Cambia a false para probar el empty state.
        let simulateReservation = true

        let entry = simulateReservation
            ? upcomingEntry()
            : emptyEntry()

        let refreshDate = Calendar.current.date(
            byAdding: .minute,
            value: 10,
            to: Date()
        ) ?? Date().addingTimeInterval(600)

        completion(
            Timeline(
                entries: [entry],
                policy: .after(refreshDate)
            )
        )
    }

    private func upcomingEntry() -> BeastWidgetEntry {
        BeastWidgetEntry(
            date: .now,
            classDate: .now.addingTimeInterval(2 * 60 * 60),
            className: "Power Ride",
            coachName: "Fernanda",
            bikeNumber: 12
        )
    }

    private func emptyEntry() -> BeastWidgetEntry {
        BeastWidgetEntry(
            date: .now,
            classDate: nil,
            className: nil,
            coachName: nil,
            bikeNumber: nil
        )
    }
}

// MARK: - Main view

struct BeastWidgetEntryView: View {

    let entry: BeastWidgetEntry

    var body: some View {
        Group {
            if entry.hasUpcomingClass {
                upcomingClassContent
            } else {
                emptyStateContent
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .containerBackground(for: .widget) {
            widgetBackground
        }
        .widgetURL(destinationURL)
    }

    private var destinationURL: URL? {
        entry.hasUpcomingClass
            ? URL(string: "beast://reservation/next")
            : URL(string: "beast://schedule")
    }

    // MARK: - Upcoming class

    private var upcomingClassContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            upcomingHeader

            Spacer(minLength: 8)

            classInformation

            Spacer(minLength: 10)

            upcomingFooter
        }
    }

    private var upcomingHeader: some View {
        HStack(spacing: 7) {
            ZStack {
                Circle()
                    .fill(BeastColors.yellowPrimary)

                Image(systemName: "flame.fill")
                    .font(.system(size: 9, weight: .black))
                    .foregroundStyle(BeastColors.buttonText)
            }
            .frame(width: 20, height: 20)

            Text("PRÓXIMA CLASE")
                .font(.system(size: 10, weight: .black))
                .tracking(1)
                .foregroundStyle(BeastColors.textSecondary)

            Spacer()

            if let classDate = entry.classDate {
                countdownBadge(classDate: classDate)
            }
        }
    }

    private func countdownBadge(
        classDate: Date
    ) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(BeastColors.success)
                .frame(width: 6, height: 6)

            Text(
                timerInterval: Date.now...classDate,
                countsDown: true,
                showsHours: true
            )
            .contentTransition(
                .numericText(countsDown: true)
            )
            .monospacedDigit()
        }
        .font(.system(size: 10, weight: .black))
        .foregroundStyle(BeastColors.buttonText)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            BeastColors.yellowPrimary,
            in: Capsule()
        )
    }

    private var classInformation: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(BeastColors.yellowPrimary)
                .frame(width: 4, height: 46)

            VStack(alignment: .leading, spacing: 4) {
                Text(
                    entry.className?.uppercased() ??
                    "PRÓXIMA CLASE"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .black,
                        design: .rounded
                    )
                )
                .italic()
                .foregroundStyle(BeastColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

                HStack(spacing: 6) {
                    if let classDate = entry.classDate {
                        Text(
                            classDate,
                            format: .dateTime
                                .hour()
                                .minute()
                        )
                        .foregroundStyle(
                            BeastColors.yellowAccent
                        )
                    }

                    Text("•")
                        .foregroundStyle(
                            BeastColors.textSecondary.opacity(0.5)
                        )

                    Text(
                        "Coach \(entry.coachName ?? "")"
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                }
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.80)
            }

            Spacer(minLength: 0)
        }
    }

    private var upcomingFooter: some View {
        HStack(spacing: 10) {
            HStack(spacing: 7) {
                Image(systemName: "figure.indoor.cycle")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(
                        BeastColors.yellowPrimary
                    )

                Text("BICI \(entry.bikeNumber ?? 0)")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                BeastColors.surface,
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .stroke(
                        BeastColors.border,
                        lineWidth: 1
                    )
            }

            Spacer()

            HStack(spacing: 6) {
                Text("VER RESERVACIÓN")

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 9, weight: .black))
            }
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(BeastColors.buttonText)
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(
                BeastColors.yellowPrimary,
                in: Capsule()
            )
        }
    }

    // MARK: - Empty state

    private var emptyStateContent: some View {
        HStack(spacing: 15) {
            emptyStateIcon

            VStack(alignment: .leading, spacing: 4) {
                Text("SIN CLASES")
                    .font(
                        .system(
                            size: 19,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Text("PRÓXIMAS")
                    .font(
                        .system(
                            size: 19,
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.yellowPrimary
                    )

                Text("Tu próxima rodada está esperando.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.80)
            }

            Spacer(minLength: 2)

            emptyStateButton
        }
    }

    private var emptyStateIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(BeastColors.surface)

            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    BeastColors.border,
                    lineWidth: 1
                )

            Circle()
                .stroke(
                    BeastColors.yellowPrimary.opacity(0.24),
                    lineWidth: 5
                )
                .padding(10)

            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(
                    BeastColors.yellowPrimary
                )
                .symbolEffect(
                    .pulse,
                    options: .repeating
                )
        }
        .frame(width: 72, height: 72)
    }

    private var emptyStateButton: some View {
        VStack(spacing: 5) {
            Image(systemName: "arrow.right")
                .font(.system(size: 13, weight: .black))

            Text("HORARIOS")
                .font(.system(size: 8, weight: .black))
        }
        .foregroundStyle(BeastColors.buttonText)
        .frame(width: 58, height: 58)
        .background(
            BeastColors.yellowPrimary,
            in: Circle()
        )
        .shadow(
            color: BeastColors.yellowPrimary.opacity(0.25),
            radius: 10,
            y: 4
        )
    }

    // MARK: - Background

    private var widgetBackground: some View {
        ZStack {
            BeastColors.background

            LinearGradient(
                colors: [
                    BeastColors.yellowPrimary.opacity(0.13),
                    BeastColors.accent.opacity(0.05),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .stroke(
                    BeastColors.yellowAccent.opacity(0.07),
                    lineWidth: 26
                )
                .frame(width: 180, height: 180)
                .offset(x: 145, y: 85)
        }
    }
}

// MARK: - Widget configuration

struct BeastWidget: Widget {

    let kind = "BeastWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: BeastWidgetProvider()
        ) { entry in
            BeastWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Próxima clase")
        .description(
            "Consulta tu próxima clase o encuentra nuevos horarios."
        )
        .supportedFamilies([
            .systemMedium
        ])
        .contentMarginsDisabled()
    }
}

// MARK: - Previews

#Preview(
    "Próxima clase",
    as: .systemMedium
) {
    BeastWidget()
} timeline: {
    BeastWidgetEntry(
        date: .now,
        classDate: .now.addingTimeInterval(2 * 60 * 60),
        className: "Power Ride",
        coachName: "Fernanda",
        bikeNumber: 12
    )
}

#Preview(
    "Sin reservación",
    as: .systemMedium
) {
    BeastWidget()
} timeline: {
    BeastWidgetEntry(
        date: .now,
        classDate: nil,
        className: nil,
        coachName: nil,
        bikeNumber: nil
    )
}
