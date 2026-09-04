import Foundation
import FirebaseFirestore

final class SchedulesRepositoryImpl: SchedulesRepository {
    private let firebaseDataSource: ScheduleFirebaseDataSourceProtocol
    private let localStore: ReservationsLocalStoreProtocol

    private var schedulesListener: ListenerRegistration?
    private var pendingListener: ListenerRegistration?

    private var currentSchedules: [ClassItem] = []
    private var currentDay = ""

    private var schedulesOnChange: (([ClassItem]) -> Void)?
    private var schedulesOnError: ((Error) -> Void)?

    init(
        firebaseDataSource: ScheduleFirebaseDataSourceProtocol = ScheduleFirebaseDataSource(),
        localStore: ReservationsLocalStoreProtocol = ReservationsLocalStore.shared
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.localStore = localStore
    }

    func observeSchedules(
        branch: String,
        day: String,
        month: String,
        onChange: @escaping ([ClassItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        schedulesListener?.remove()

        currentDay = day
        schedulesOnChange = onChange
        schedulesOnError = onError

        schedulesListener = firebaseDataSource.observeSchedules(
            branch: branch,
            day: day,
            month: month,
            onChange: { [weak self] schedules in
                guard let self else { return }

                self.currentSchedules = schedules

                Task {
                    await self.publishSchedules()
                }
            },
            onError: { [weak self] error in
                guard let self else { return }
                self.schedulesOnError?(error)
            }
        )
    }

    func stopSchedulesObserver() {
        schedulesListener?.remove()
        schedulesListener = nil
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
            email: email,
            onChange: { [weak self] reservations in
                guard let self else { return }

                Task {
                    await self.localStore.replaceReservations(
                        reservations,
                        forMonth: month
                    )

                    await self.publishSchedules()

                    await MainActor.run {
                        NotificationCenter.default.post(
                            name: .reservationsDidChange,
                            object: nil
                        )

                        onChange()
                    }
                }
            },
            onError: { error in
                onError(error)
            }
        )
    }

    func stopPendingSchedulesObserver() {
        pendingListener?.remove()
        pendingListener = nil
    }

    func upcomingReservations(
        day: String
    ) async -> [ClassItemEntity] {
        await localStore.reservations(
            for: day
        )
        .sorted {
            $0.time < $1.time
        }
    }

    func reservationHistory(
        day: String
    ) async -> [ClassItemEntity] {
        await localStore.history(
            before: day
        )
    }

    private func publishSchedules() async {
        guard !currentDay.isEmpty else {
            return
        }

        let reservations = await localStore.reservations(
            for: currentDay
        )

        let updatedSchedules = currentSchedules
            .map { schedule in
                var updated = schedule

                updated.isScheduled = reservations.contains {
                    $0.diaAgendado == currentDay &&
                    normalizeTime($0.time) ==
                    normalizeTime(schedule.time)
                }

                return updated
            }
            .sorted {
                $0.time < $1.time
            }

        await MainActor.run {
            self.schedulesOnChange?(
                updatedSchedules
            )
        }
    }

    private func normalizeTime(
        _ value: String
    ) -> String {
        let value = value.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let components = value.split(
            separator: ":"
        )

        guard
            components.count >= 2,
            let hour = Int(components[0]),
            let minute = Int(components[1])
        else {
            return value
        }

        return String(
            format: "%02d:%02d",
            hour,
            minute
        )
    }

    deinit {
        schedulesListener?.remove()
        pendingListener?.remove()
    }
}
