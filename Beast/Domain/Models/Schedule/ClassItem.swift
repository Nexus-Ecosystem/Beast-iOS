import Foundation

struct ClassItem: Identifiable, Equatable {
    let id: String
    let name: String
    let coach: String
    let photo: String
    let time: String
    let duration: Int
    let level: Int
    let agenda: Int
    let total: Int
    let cancelled: Bool
    var isScheduled: Bool

    init(
        id: String = "",
        name: String = "",
        coach: String = "",
        photo: String = "",
        time: String = "",
        duration: Int = 0,
        level: Int = 1,
        agenda: Int = 0,
        total: Int = 0,
        cancelled: Bool = false,
        isScheduled: Bool = false
    ) {
        self.id = id
        self.name = name
        self.coach = coach
        self.photo = photo
        self.time = time
        self.duration = duration
        self.level = level
        self.agenda = agenda
        self.total = total
        self.cancelled = cancelled
        self.isScheduled = isScheduled
    }

    var availableSpots: Int {
        max(total - agenda, 0)
    }

    var capacityProgress: Double {
        guard total > 0 else {
            return 0
        }

        return min(
            Double(agenda) / Double(total),
            1
        )
    }

    var difficultyName: String {
        switch level {
        case 1:
            return "Fácil"

        case 2:
            return "Media"

        case 3:
            return "Retadora"

        case 4:
            return "Difícil"

        default:
            return "Fácil"
        }
    }
}
