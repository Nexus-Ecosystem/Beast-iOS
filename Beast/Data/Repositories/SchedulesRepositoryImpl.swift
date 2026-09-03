import Foundation
import FirebaseFirestore

final class SchedulesRepositoryImpl: SchedulesRepository {
    private let firebaseDataSource: ScheduleFirebaseDataSourceProtocol
    private let localStore: ReservationsLocalStoreProtocol

    private var pendingListener: ListenerRegistration?

    init(
        firebaseDataSource: ScheduleFirebaseDataSourceProtocol = ScheduleFirebaseDataSource(),
        localStore: ReservationsLocalStoreProtocol = ReservationsLocalStore.shared
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.localStore = localStore
    }

    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        pendingListener?.remove()

        pendingListener = firebaseDataSource.observePendingSchedules(
            branch: branch,
            month: month,
            email: email
        ) { [weak self] reservations in
            guard let self else { return }

            Task {
                await self.localStore.saveReservations(
                    reservations
                )

                await MainActor.run {
                    onChange()
                }
            }

        } onError: { error in
            onError(error)
        }
    }

    func stopPendingSchedulesObserver() {
        pendingListener?.remove()
        pendingListener = nil
    }

    func upcomingReservation(
        day: String
    ) async -> ClassItemEntity? {
        let reservations = await localStore.reservations(
            for: day
        )

        return reservations.first
    }

    func reservationHistory(
        day: String
    ) async -> [ClassItemEntity] {
        await localStore.history(
            before: day
        )
    }

    deinit {
        pendingListener?.remove()
    }
}
