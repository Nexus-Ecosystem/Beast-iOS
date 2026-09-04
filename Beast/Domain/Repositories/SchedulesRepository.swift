import Foundation

protocol SchedulesRepository {
    func observeSchedules(
        branch: String,
        day: String,
        month: String,
        onChange: @escaping ([ClassItem]) -> Void,
        onError: @escaping (Error) -> Void
    )

    func stopSchedulesObserver()

    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    )

    func stopPendingSchedulesObserver()

    func upcomingReservations(
        day: String
    ) async -> [ClassItemEntity]

    func reservationHistory(
        day: String
    ) async -> [ClassItemEntity]
}
