import Foundation

protocol ReservationsLocalStoreProtocol {
    func saveReservations(_ reservations: [ClassItemEntity]) async

    func replaceReservations(
        _ reservations: [ClassItemEntity],
        forMonth month: String
    ) async

    func saveReservation(_ reservation: ClassItemEntity) async

    func reservation(
        time: String,
        day: String
    ) async -> ClassItemEntity?

    func reservations(
        for day: String
    ) async -> [ClassItemEntity]

    func history(
        before day: String
    ) async -> [ClassItemEntity]

    func deleteReservation(
        time: String,
        day: String
    ) async

    func clear() async
}

actor ReservationsLocalStore: ReservationsLocalStoreProtocol {
    static let shared = ReservationsLocalStore()

    private enum Keys {
        static let reservations = "beast.reservations"
    }

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    func saveReservations(
        _ reservations: [ClassItemEntity]
    ) async {
        var current = loadReservations()

        for reservation in reservations {
            current.removeAll {
                $0.diaAgendado == reservation.diaAgendado &&
                $0.time == reservation.time
            }

            current.append(
                reservation
            )
        }

        save(current)
    }

    func replaceReservations(
        _ reservations: [ClassItemEntity],
        forMonth month: String
    ) async {
        var current = loadReservations()

        current.removeAll {
            $0.diaAgendado.hasPrefix(month)
        }

        current.append(
            contentsOf: reservations
        )

        save(current)
    }

    func saveReservation(
        _ reservation: ClassItemEntity
    ) async {
        var current = loadReservations()

        current.removeAll {
            $0.diaAgendado == reservation.diaAgendado &&
            $0.time == reservation.time
        }

        current.append(
            reservation
        )

        save(current)
    }

    func reservation(
        time: String,
        day: String
    ) async -> ClassItemEntity? {
        loadReservations()
            .first {
                $0.time == time &&
                $0.diaAgendado == day
            }
    }

    func reservations(
        for day: String
    ) async -> [ClassItemEntity] {
        loadReservations()
            .filter {
                $0.diaAgendado == day
            }
            .sorted {
                $0.time < $1.time
            }
    }

    func history(
        before day: String
    ) async -> [ClassItemEntity] {
        loadReservations()
            .filter {
                $0.diaAgendado < day
            }
            .sorted {
                if $0.diaAgendado == $1.diaAgendado {
                    return $0.time > $1.time
                }

                return $0.diaAgendado > $1.diaAgendado
            }
    }

    func deleteReservation(
        time: String,
        day: String
    ) async {
        var current = loadReservations()

        current.removeAll {
            $0.time == time &&
            $0.diaAgendado == day
        }

        save(current)
    }

    func clear() async {
        userDefaults.removeObject(
            forKey: Keys.reservations
        )
    }

    private func loadReservations() -> [ClassItemEntity] {
        guard
            let data = userDefaults.data(
                forKey: Keys.reservations
            ),
            let reservations = try? decoder.decode(
                [ClassItemEntity].self,
                from: data
            )
        else {
            return []
        }

        return reservations
    }

    private func save(
        _ reservations: [ClassItemEntity]
    ) {
        guard let data = try? encoder.encode(
            reservations
        ) else {
            return
        }

        userDefaults.set(
            data,
            forKey: Keys.reservations
        )
    }
}
