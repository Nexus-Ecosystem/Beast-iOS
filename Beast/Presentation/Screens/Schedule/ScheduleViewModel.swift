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
    @Published var showNoMembership = false
    @Published var bookingMessage = ""

    private let schedulesUseCase: SchedulesUseCase
    private let bookingUseCase: BookingClassUseCase
    private let profileUseCase: ProfileUseCase
    private let storage: AppStorageManager

    private var branch = ""
    private var email = ""
    private var bookingProfile: AllDataProfileUserSystem?
    private var liveProfile: ProfileDisplayModel = .empty
    private var didStart = false

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        bookingUseCase: BookingClassUseCase = BookingClassUseCase(),
        profileUseCase: ProfileUseCase = ProfileUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.bookingUseCase = bookingUseCase
        self.profileUseCase = profileUseCase
        self.storage = storage
    }

    // MARK: - Schedule State

    var visibleSchedules: [ClassItem] {
        guard Calendar.current.isDateInToday(selectedDate) else {
            return schedules
        }

        return schedules.filter {
            isUpcoming(time: $0.time)
        }
    }

    var hasSchedules: Bool {
        !visibleSchedules.isEmpty
    }

    var hasScheduledClass: Bool {
        schedules.contains {
            $0.isScheduled && !$0.cancelled
        }
    }

    // MARK: - Membership

    var hasActiveMembership: Bool {
        guard !liveProfile.packageId.isEmpty,
              liveProfile.packageId != "-" else {
            return false
        }

        if isPackageExpired(liveProfile.packageExpiration) {
            return false
        }

        // Membresía mensual
        if liveProfile.packageType == 1 {
            return true
        }

        // Paquete por número de clases
        return liveProfile.classesTaken < liveProfile.totalClasses
    }

    var membershipUnavailableReason: MembershipUnavailableReason? {
        guard !liveProfile.packageId.isEmpty,
              liveProfile.packageId != "-" else {
            return .noPackage
        }

        if isPackageExpired(liveProfile.packageExpiration) {
            return .expired
        }

        if liveProfile.packageType != 1,
           liveProfile.classesTaken >= liveProfile.totalClasses {
            return .consumed
        }

        return nil
    }

    // MARK: - Lifecycle

    func onAppear() {
        guard !didStart else {
            return
        }

        didStart = true
        errorMessage = nil

        guard let localProfile = storage.getProfile() else {
            schedules = []
            errorMessage = "No se encontró el perfil del usuario."
            return
        }

        bookingProfile = localProfile
        email = localProfile.email
        branch = localProfile.branches.first ?? ""

        guard !email.isEmpty else {
            errorMessage = "No se encontró el correo del usuario."
            return
        }

        guard !branch.isEmpty else {
            errorMessage = "No se encontró la sucursal del usuario."
            return
        }

        observeProfile()
        observePendingSchedules()
        observeSchedules()
    }

    func stop() {
        didStart = false
        schedulesUseCase.stopSchedulesObserver()
        schedulesUseCase.stopPendingSchedulesObserver()
        profileUseCase.stopProfileObserver()
    }

    // MARK: - Live Profile

    private func observeProfile() {
        guard !email.isEmpty else {
            return
        }

        profileUseCase.observeProfile(
            email: email,
            onChange: { [weak self] profile in
                guard let self else {
                    return
                }

                self.liveProfile = profile
                self.objectWillChange.send()
            },
            onError: { [weak self] error in
                self?.errorMessage = error.localizedDescription
            }
        )
    }

    // MARK: - Date Selection

    func selectDate(_ date: Date) {
        guard !Calendar.current.isDate(date, inSameDayAs: selectedDate) else {
            return
        }

        let previousMonth = selectedDate.scheduleMonth
        selectedDate = date

        if previousMonth != date.scheduleMonth {
            observePendingSchedules()
        }

        observeSchedules()
    }

    // MARK: - Class Selection

    func selectClass(_ item: ClassItem) {
        guard !item.cancelled else {
            return
        }

        selectedClass = item

        // Cancelar no requiere membresía activa.
        if item.isScheduled {
            guard canCancel(item) else {
                return
            }

            showCancellationConfirmation = true
            return
        }

        // Nueva reserva sí requiere paquete/membresía activa.
        guard hasActiveMembership else {
            showNoMembership = true
            return
        }

        if liveProfile.packageType == 1 {
            if hasScheduledClass {
                showExtraBookingConfirmation = true
            } else {
                showBookingConfirmation = true
            }

            return
        }

        if liveProfile.classesTaken < liveProfile.totalClasses {
            showBookingConfirmation = true
        } else {
            showNoMembership = true
        }
    }

    // MARK: - Booking Actions

    func confirmBooking() {
        showBookingConfirmation = false

        guard hasActiveMembership else {
            showNoMembership = true
            return
        }

        Task {
            await performBooking(action: .book)
        }
    }

    func confirmExtraBooking() {
        showExtraBookingConfirmation = false

        guard hasActiveMembership else {
            showNoMembership = true
            return
        }

        Task {
            await performBooking(action: .book)
        }
    }

    func confirmCancellation() {
        showCancellationConfirmation = false

        Task {
            await performBooking(action: .cancel)
        }
    }

    // MARK: - Dialogs

    func closeConfirmation() {
        showBookingConfirmation = false
        showCancellationConfirmation = false
        showExtraBookingConfirmation = false
        selectedClass = nil
    }

    func closeNoMembership() {
        showNoMembership = false
        selectedClass = nil
    }

    func closeSuccess() {
        showBookingSuccess = false
        selectedClass = nil
    }

    func closeError() {
        showBookingError = false
    }

    // MARK: - Booking Rules

    func isExtraBooking(_ item: ClassItem) -> Bool {
        liveProfile.packageType == 1 &&
        !item.isScheduled &&
        !item.cancelled &&
        hasScheduledClass
    }

    func canCancel(_ item: ClassItem) -> Bool {
        item.isScheduled &&
        !item.cancelled &&
        isCancelable(time: item.time)
    }

    // MARK: - Perform Booking

    private func performBooking(action: BookingAction) async {
        guard let selectedClass else {
            return
        }

        if action == .book && !hasActiveMembership {
            showNoMembership = true
            return
        }

        /*
         BookingClassUseCase todavía necesita
         AllDataProfileUserSystem.

         Intentamos obtener la versión más reciente del storage.
         Si todavía no se sincronizó, usamos la que teníamos.
        */
        if let updatedProfile = storage.getProfile() {
            bookingProfile = updatedProfile
        }

        guard let bookingProfile else {
            bookingMessage = "No se encontró la información del usuario."
            showBookingError = true
            return
        }

        isBookingLoading = true
        bookingMessage = ""

        do {
            let response = try await bookingUseCase.execute(
                branch: branch,
                date: selectedDate.scheduleDay,
                item: selectedClass,
                profile: bookingProfile,
                action: action
            )

            isBookingLoading = false

            guard response.success != false else {
                bookingMessage = response.message ??
                    "No fue posible realizar la operación."
                showBookingError = true
                return
            }

            observeSchedules()

            switch action {
            case .book:
                bookingMessage = "Se agendó tu clase correctamente"

            case .cancel:
                bookingMessage = "Se canceló tu clase correctamente, te esperamos pronto!"
            }

            showBookingSuccess = true
        } catch {
            isBookingLoading = false
            bookingMessage = error.localizedDescription
            showBookingError = true
        }
    }

    // MARK: - Schedule Observers

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
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        )
    }

    private func observePendingSchedules() {
        guard !branch.isEmpty, !email.isEmpty else {
            return
        }

        schedulesUseCase.observePendingSchedules(
            branch: branch,
            month: selectedDate.scheduleMonth,
            email: email,
            onChange: {},
            onError: { [weak self] error in
                self?.errorMessage = error.localizedDescription
            }
        )
    }

    // MARK: - Package Expiration

    private func isPackageExpired(_ expiration: String) -> Bool {
        guard !expiration.isEmpty else {
            return true
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"

        guard let expirationDate = formatter.date(from: expiration) else {
            return false
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expirationDay = calendar.startOfDay(for: expirationDate)

        return today > expirationDay
    }

    // MARK: - Time Rules

    private func isUpcoming(time: String) -> Bool {
        let values = time.split(separator: ":")

        guard values.count >= 2,
              let hour = Int(values[0]),
              let minute = Int(values[1]) else {
            return true
        }

        let now = Date()

        guard let classDate = Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: now
        ) else {
            return true
        }

        return classDate > now
    }

    private func isCancelable(time: String) -> Bool {
        guard Calendar.current.isDateInToday(selectedDate) else {
            return true
        }

        let values = time.split(separator: ":")

        guard values.count >= 2,
              let hour = Int(values[0]),
              let minute = Int(values[1]) else {
            return true
        }

        guard let classDate = Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: Date()
        ) else {
            return true
        }

        return Date() < classDate.addingTimeInterval(-7200)
    }

    deinit {
        schedulesUseCase.stopSchedulesObserver()
        schedulesUseCase.stopPendingSchedulesObserver()
        profileUseCase.stopProfileObserver()
    }
}

enum MembershipUnavailableReason {
    case noPackage
    case expired
    case consumed
}
