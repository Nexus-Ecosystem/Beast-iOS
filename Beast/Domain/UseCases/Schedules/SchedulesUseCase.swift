import Foundation

final class SchedulesUseCase {
    private let repository: SchedulesRepository

    init(
        repository: SchedulesRepository = SchedulesRepositoryImpl()
    ) {
        self.repository = repository
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

    func upcomingReservation(
        day: String
    ) async -> ClassItemEntity? {
        await repository.upcomingReservation(
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
