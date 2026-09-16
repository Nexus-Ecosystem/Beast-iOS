import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var upcomingClasses: [ClassItemEntity] = []
    @Published private(set) var classHistory: [ClassItemEntity] = []
    @Published private(set) var profile: AllDataProfileUserSystem?
    @Published private(set) var branchName = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let schedulesUseCase: SchedulesUseCase
    private let storage: AppStorageManager

    private var cancellables = Set<AnyCancellable>()

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.storage = storage

        observeReservationChanges()
    }

    // MARK: - Public

    func load() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        guard let storedProfile = storage.getProfile() else {
            clearData()
            errorMessage = "No se encontró la información del usuario."
            return
        }

        profile = storedProfile

        guard !storedProfile.email.isEmpty else {
            clearScheduleData()
            errorMessage = "No se encontró el correo del usuario."
            return
        }

        guard let branch = storedProfile.branches
            .first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
        else {
            branchName = ""
            clearScheduleData()
            errorMessage = "No se encontró una sucursal asociada."
            return
        }

        branchName = branch.trimmingCharacters(in: .whitespacesAndNewlines)

        let currentDate = Date()
        let day = Self.dayFormatter.string(from: currentDate)
        let month = Self.monthFormatter.string(from: currentDate)

        await refreshLocalData(day: day)

        observePendingSchedules(
            branch: branchName,
            month: month,
            email: storedProfile.email
        )
    }

    func refresh() async {
        errorMessage = nil

        await refreshLocalData(
            day: Self.dayFormatter.string(from: Date())
        )
    }

    func stop() {
        schedulesUseCase.stopPendingSchedulesObserver()
    }

    func resetError() {
        errorMessage = nil
    }

    // MARK: - Pending Schedules

    private func observePendingSchedules(
        branch: String,
        month: String,
        email: String
    ) {
        schedulesUseCase.stopPendingSchedulesObserver()

        schedulesUseCase.observePendingSchedules(
            branch: branch,
            month: month,
            email: email,
            onChange: { [weak self] in
                guard let self else { return }

                Task { @MainActor in
                    await self.refreshLocalData(
                        day: Self.dayFormatter.string(from: Date())
                    )
                }
            },
            onError: { [weak self] error in
                Task { @MainActor in
                    self?.errorMessage = error.localizedDescription
                }
            }
        )
    }

    // MARK: - Reservation Changes

    private func observeReservationChanges() {
        NotificationCenter.default
            .publisher(for: .reservationsDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }

                Task { @MainActor in
                    await self.refreshLocalData(
                        day: Self.dayFormatter.string(from: Date())
                    )
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Data

    private func refreshLocalData(day: String) async {
        upcomingClasses = await schedulesUseCase
            .upcomingReservations(day: day)

        classHistory = await schedulesUseCase
            .reservationHistory(day: day)
    }

    private func clearScheduleData() {
        upcomingClasses = []
        classHistory = []
    }

    private func clearData() {
        profile = nil
        branchName = ""
        clearScheduleData()
    }

    // MARK: - Formatters

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
}
