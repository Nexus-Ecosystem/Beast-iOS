import Foundation

protocol SchedulesRepository {
    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    )

    func stopPendingSchedulesObserver()

    func upcomingReservation(
        day: String
    ) async -> ClassItemEntity?

    func reservationHistory(
        day: String
    ) async -> [ClassItemEntity]
}
