import Foundation

extension Date {
    var scheduleDay: String {
        Self.dayFormatter.string(
            from: self
        )
    }

    var scheduleMonth: String {
        Self.monthFormatter.string(
            from: self
        )
    }

    var scheduleMonthTitle: String {
        Self.monthTitleFormatter.string(
            from: self
        )
    }

    var scheduleDayName: String {
        let value = Self.dayNameFormatter
            .string(from: self)
            .replacingOccurrences(
                of: ".",
                with: ""
            )

        guard let first = value.first else {
            return value
        }

        return String(first).uppercased()
            + value.dropFirst().lowercased()
    }

    var scheduleDayNumber: String {
        String(
            Calendar.current.component(
                .day,
                from: self
            )
        )
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(
            identifier: .gregorian
        )
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(
            identifier: .gregorian
        )
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()

    private static let monthTitleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat = "MMMM 'del' yyyy"
        return formatter
    }()

    private static let dayNameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat = "EEE"
        return formatter
    }()
}
