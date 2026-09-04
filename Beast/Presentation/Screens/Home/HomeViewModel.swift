import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var upcomingClasses: [ClassItemEntity] = []
    @Published private(set) var classHistory: [ClassItemEntity] = []
    @Published private(set) var profile: AllDataProfileUserSystem?
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

    func load() async {
        isLoading = true
        errorMessage = nil

        profile = storage.getProfile()

        guard let profile else {
            isLoading = false
            errorMessage = "No se encontró la información del usuario."
            return
        }

        guard
            !profile.email.isEmpty,
            let branch = profile.branches.first,
            !branch.isEmpty
        else {
            isLoading = false
            errorMessage = "No se encontró una sucursal asociada."
            return
        }

        let day = Self.dayFormatter.string(
            from: Date()
        )

        let month = Self.monthFormatter.string(
            from: Date()
        )

        await refreshLocalData(
            day: day
        )

        schedulesUseCase.observePendingSchedules(
            branch: branch,
            month: month,
            email: profile.email,
            onChange: { [weak self] in
                guard let self else { return }

                Task { @MainActor in
                    await self.refreshLocalData(
                        day: Self.dayFormatter.string(
                            from: Date()
                        )
                    )
                }
            },
            onError: { [weak self] error in
                Task { @MainActor in
                    self?.errorMessage =
                        error.localizedDescription
                }
            }
        )

        isLoading = false
    }

    func refresh() async {
        await refreshLocalData(
            day: Self.dayFormatter.string(
                from: Date()
            )
        )
    }

    func stop() {
        schedulesUseCase.stopPendingSchedulesObserver()
    }

    func resetError() {
        errorMessage = nil
    }

    private func observeReservationChanges() {
        NotificationCenter.default
            .publisher(
                for: .reservationsDidChange
            )
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] _ in
                guard let self else { return }

                Task { @MainActor in
                    await self.refreshLocalData(
                        day: Self.dayFormatter.string(
                            from: Date()
                        )
                    )
                }
            }
            .store(
                in: &cancellables
            )
    }

    private func refreshLocalData(
        day: String
    ) async {
        upcomingClasses = await schedulesUseCase
            .upcomingReservations(
                day: day
            )

        classHistory = await schedulesUseCase
            .reservationHistory(
                day: day
            )
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
}
