import Foundation

final class SchedulesUseCase {
    private let repository: SchedulesRepository

    init(
        repository: SchedulesRepository = SchedulesRepositoryImpl()
    ) {
        self.repository = repository
    }

    func observeSchedules(
        branch: String,
        day: String,
        month: String,
        onChange: @escaping ([ClassItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        repository.observeSchedules(
            branch: branch,
            day: day,
            month: month,
            onChange: onChange,
            onError: onError
        )
    }

    func stopSchedulesObserver() {
        repository.stopSchedulesObserver()
    }

    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        repository.observePendingSchedules(
            branch: branch,
            month: month,
            email: email,
            onChange: onChange,
            onError: onError
        )
    }

    func stopPendingSchedulesObserver() {
        repository.stopPendingSchedulesObserver()
    }

    func upcomingReservations(
        day: String
    ) async -> [ClassItemEntity] {
        await repository.upcomingReservations(
            day: day
        )
    }

    func reservationHistory(
        day: String
    ) async -> [ClassItemEntity] {
        await repository.reservationHistory(
            day: day
        )
    }
}
