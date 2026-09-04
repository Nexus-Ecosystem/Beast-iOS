import Foundation
import Combine

@MainActor
final class ScheduleViewModel: ObservableObject {
    @Published private(set) var schedules: [ClassItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isBookingLoading = false
    @Published private(set) var errorMessage: String?

    @Published var selectedDate = Date()
    @Published var selectedClass: ClassItem?

    @Published var showBookingConfirmation = false
    @Published var showCancellationConfirmation = false
    @Published var showExtraBookingConfirmation = false
    @Published var showBookingSuccess = false
    @Published var showBookingError = false

    @Published var bookingMessage = ""

    private let schedulesUseCase: SchedulesUseCase
    private let bookingUseCase: BookingClassUseCase
    private let storage: AppStorageManager

    private var branch = ""
    private var email = ""
    private var profile: AllDataProfileUserSystem?

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        bookingUseCase: BookingClassUseCase = BookingClassUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.bookingUseCase = bookingUseCase
        self.storage = storage
    }

    var visibleSchedules: [ClassItem] {
        guard Calendar.current.isDateInToday(
            selectedDate
        ) else {
            return schedules
        }

        return schedules.filter {
            isUpcoming(
                time: $0.time
            )
        }
    }

    var hasSchedules: Bool {
        !visibleSchedules.isEmpty
    }

    var hasScheduledClass: Bool {
        schedules.contains {
            $0.isScheduled
        }
    }

    func onAppear() {
        guard let profile = storage.getProfile() else {
            schedules = []
            errorMessage =
                "No se encontró el perfil del usuario."
            return
        }

        self.profile = profile
        email = profile.email
        branch = profile.branches.first ?? ""

        guard !email.isEmpty else {
            errorMessage =
                "No se encontró el correo del usuario."
            return
        }

        guard !branch.isEmpty else {
            errorMessage =
                "No se encontró la sucursal del usuario."
            return
        }

        observePendingSchedules()
        observeSchedules()
    }

    func selectDate(
        _ date: Date
    ) {
        guard !Calendar.current.isDate(
            date,
            inSameDayAs: selectedDate
        ) else {
            return
        }

        let previousMonth =
            selectedDate.scheduleMonth

        selectedDate = date

        if previousMonth != date.scheduleMonth {
            observePendingSchedules()
        }

        observeSchedules()
    }

    func selectClass(
        _ item: ClassItem
    ) {
        guard !item.cancelled else {
            return
        }

        selectedClass = item

        if item.isScheduled {
            guard canCancel(item) else {
                return
            }

            showCancellationConfirmation = true
            return
        }

        if hasScheduledClass {
            showExtraBookingConfirmation = true
        } else {
            showBookingConfirmation = true
        }
    }

    func confirmBooking() {
        showBookingConfirmation = false

        Task {
            await performBooking(
                action: .book
            )
        }
    }

    func confirmExtraBooking() {
        showExtraBookingConfirmation = false

        Task {
            await performBooking(
                action: .book
            )
        }
    }

    func confirmCancellation() {
        showCancellationConfirmation = false

        Task {
            await performBooking(
                action: .cancel
            )
        }
    }

    func closeConfirmation() {
        showBookingConfirmation = false
        showCancellationConfirmation = false
        showExtraBookingConfirmation = false
        selectedClass = nil
    }

    func closeSuccess() {
        showBookingSuccess = false
        selectedClass = nil
    }

    func closeError() {
        showBookingError = false
    }

    func isExtraBooking(
        _ item: ClassItem
    ) -> Bool {
        !item.isScheduled &&
        !item.cancelled &&
        hasScheduledClass
    }

    func canCancel(
        _ item: ClassItem
    ) -> Bool {
        item.isScheduled &&
        !item.cancelled &&
        isCancelable(
            time: item.time
        )
    }

    private func performBooking(
        action: BookingAction
    ) async {
        guard
            let selectedClass,
            let profile
        else {
            return
        }

        isBookingLoading = true
        bookingMessage = ""

        do {
            let response =
                try await bookingUseCase.execute(
                    branch: branch,
                    date: selectedDate.scheduleDay,
                    item: selectedClass,
                    profile: profile,
                    action: action
                )

            isBookingLoading = false

            if response.success == false {
                bookingMessage =
                    response.message ??
                    "No fue posible realizar la operación."

                showBookingError = true
                return
            }

            /*
             Android hace:

             getRemindersByDay(selectedDay.value)

             Nosotros reiniciamos la observación del día.
             */
            observeSchedules()

            switch action {
            case .book:
                bookingMessage =
                    "Se agendó tu clase correctamente"

            case .cancel:
                bookingMessage =
                    "Se canceló tu clase correctamente, te esperamos pronto!"
            }

            showBookingSuccess = true

        } catch {
            isBookingLoading = false
            bookingMessage =
                error.localizedDescription
            showBookingError = true
        }
    }

    private func observeSchedules() {
        guard !branch.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        schedulesUseCase.observeSchedules(
            branch: branch,
            day: selectedDate.scheduleDay,
            month: selectedDate.scheduleMonth,
            onChange: { [weak self] schedules in
                guard let self else {
                    return
                }

                self.schedules = schedules
                self.isLoading = false
            },
            onError: { [weak self] error in
                guard let self else {
                    return
                }

                self.schedules = []
                self.errorMessage =
                    error.localizedDescription
                self.isLoading = false
            }
        )
    }

    private func observePendingSchedules() {
        guard
            !branch.isEmpty,
            !email.isEmpty
        else {
            return
        }

        schedulesUseCase.observePendingSchedules(
            branch: branch,
            month: selectedDate.scheduleMonth,
            email: email,
            onChange: {},
            onError: { [weak self] error in
                self?.errorMessage =
                    error.localizedDescription
            }
        )
    }

    private func isUpcoming(
        time: String
    ) -> Bool {
        let values = time.split(
            separator: ":"
        )

        guard
            values.count >= 2,
            let hour = Int(values[0]),
            let minute = Int(values[1])
        else {
            return true
        }

        let now = Date()

        guard let classDate =
            Calendar.current.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: now
            )
        else {
            return true
        }

        return classDate > now
    }

    private func isCancelable(
        time: String
    ) -> Bool {
        guard Calendar.current.isDateInToday(
            selectedDate
        ) else {
            return true
        }

        let values = time.split(
            separator: ":"
        )

        guard
            values.count >= 2,
            let hour = Int(values[0]),
            let minute = Int(values[1])
        else {
            return true
        }

        guard let classDate =
            Calendar.current.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: Date()
            )
        else {
            return true
        }

        return Date() <
            classDate.addingTimeInterval(
                -7200
            )
    }

    deinit {
        schedulesUseCase.stopSchedulesObserver()
        schedulesUseCase.stopPendingSchedulesObserver()
    }
}
