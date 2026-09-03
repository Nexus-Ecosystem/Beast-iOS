import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var upcomingClass: ClassItemEntity?
    @Published private(set) var classHistory: [ClassItemEntity] = []
    @Published private(set) var profile: AllDataProfileUserSystem?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let schedulesUseCase: SchedulesUseCase
    private let storage: AppStorageManager

    init(
        schedulesUseCase: SchedulesUseCase = SchedulesUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.schedulesUseCase = schedulesUseCase
        self.storage = storage
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
            email: profile.email
        ) { [weak self] in
            guard let self else { return }

            Task {
                await self.refreshLocalData(
                    day: day
                )
            }

        } onError: { [weak self] error in
            Task { @MainActor in
                self?.errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }

    func refresh() async {
        let day = Self.dayFormatter.string(
            from: Date()
        )

        await refreshLocalData(
            day: day
        )
    }

    func stop() {
        schedulesUseCase.stopPendingSchedulesObserver()
    }

    func resetError() {
        errorMessage = nil
    }

    private func refreshLocalData(
        day: String
    ) async {
        upcomingClass = await schedulesUseCase
            .upcomingReservation(
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
