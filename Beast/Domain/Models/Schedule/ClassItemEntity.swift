import Foundation

struct ClassItemEntity: Codable, Identifiable, Equatable {
    let id: Int?
    let idFirebase: String
    let sucursalAgendada: String
    let diaAgendado: String
    let coach: String
    let name: String
    let time: String
    let duration: Int
    let level: Int
    let agenda: Int
    let total: Int
    let photo: String
    var isScheduled: Bool

    init(
        id: Int? = 0,
        idFirebase: String = "",
        sucursalAgendada: String = "",
        diaAgendado: String = "",
        coach: String = "",
        name: String = "",
        time: String = "",
        duration: Int = 0,
        level: Int = 0,
        agenda: Int = 0,
        total: Int = 0,
        photo: String = "",
        isScheduled: Bool = false
    ) {
        self.id = id
        self.idFirebase = idFirebase
        self.sucursalAgendada = sucursalAgendada
        self.diaAgendado = diaAgendado
        self.coach = coach
        self.name = name
        self.time = time
        self.duration = duration
        self.level = level
        self.agenda = agenda
        self.total = total
        self.photo = photo
        self.isScheduled = isScheduled
    }
}
