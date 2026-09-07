import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var reservations: [ClassItemEntity] = []
    @Published private(set) var filteredReservations: [ClassItemEntity] = []

    @Published var selectedFilter: HistoryFilter = .month
    @Published var selectedDate = Date()

    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let schedulesUseCase: SchedulesUseCase

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase()
    ) {
        self.schedulesUseCase = schedulesUseCase
    }

    var periodTitle: String {
        switch selectedFilter {
        case .week:
            return weekTitle

        case .month:
            return Self.monthTitleFormatter.string(
                from: selectedDate
            )
            .capitalized

        case .year:
            return Self.yearFormatter.string(
                from: selectedDate
            )
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        await refresh()

        isLoading = false
    }

    func refresh() async {
        reservations = await schedulesUseCase
            .reservationHistory(
                day: Self.apiDayFormatter.string(
                    from: Date()
                )
            )

        applyFilter()
    }

    func selectFilter(
        _ filter: HistoryFilter
    ) {
        selectedFilter = filter
        selectedDate = Date()

        applyFilter()
    }

    func previousPeriod() {
        guard let date = dateByAdding(
            value: -1
        ) else {
            return
        }

        selectedDate = date
        applyFilter()
    }

    func nextPeriod() {
        guard let date = dateByAdding(
            value: 1
        ) else {
            return
        }

        selectedDate = date
        applyFilter()
    }

    func resetError() {
        errorMessage = nil
    }

    private func applyFilter() {
        let calendar = Calendar.current

        filteredReservations = reservations.filter {
            guard let reservationDate = Self.reservationDateFormatter.date(
                from: $0.diaAgendado
            ) else {
                return false
            }

            switch selectedFilter {
            case .week:
                return calendar.isDate(
                    reservationDate,
                    equalTo: selectedDate,
                    toGranularity: .weekOfYear
                )

            case .month:
                return calendar.isDate(
                    reservationDate,
                    equalTo: selectedDate,
                    toGranularity: .month
                )

            case .year:
                return calendar.isDate(
                    reservationDate,
                    equalTo: selectedDate,
                    toGranularity: .year
                )
            }
        }
        .sorted {
            guard
                let firstDate = Self.reservationDateFormatter.date(
                    from: $0.diaAgendado
                ),
                let secondDate = Self.reservationDateFormatter.date(
                    from: $1.diaAgendado
                )
            else {
                return false
            }

            if firstDate == secondDate {
                return $0.time > $1.time
            }

            return firstDate > secondDate
        }
    }

    private func dateByAdding(
        value: Int
    ) -> Date? {
        let calendar = Calendar.current

        switch selectedFilter {
        case .week:
            return calendar.date(
                byAdding: .weekOfYear,
                value: value,
                to: selectedDate
            )

        case .month:
            return calendar.date(
                byAdding: .month,
                value: value,
                to: selectedDate
            )

        case .year:
            return calendar.date(
                byAdding: .year,
                value: value,
                to: selectedDate
            )
        }
    }

    private var weekTitle: String {
        let calendar = Calendar.current

        guard let interval = calendar.dateInterval(
            of: .weekOfYear,
            for: selectedDate
        ) else {
            return ""
        }

        let start = interval.start

        guard let end = calendar.date(
            byAdding: .day,
            value: 6,
            to: start
        ) else {
            return ""
        }

        let startDay = Self.dayFormatter.string(
            from: start
        )

        let endDay = Self.dayFormatter.string(
            from: end
        )

        let month = Self.shortMonthFormatter.string(
            from: end
        )

        return "\(startDay) - \(endDay) \(month)"
            .capitalized
    }

    private static let apiDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let reservationDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let monthTitleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat = "d"
        return formatter
    }()

    private static let shortMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat = "MMM"
        return formatter
    }()
}
