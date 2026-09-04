import Foundation

struct BookingClassRequest: Encodable {
    let correo: String
    let nombre: String
    let telefono: String
    let idSucursal: String
    let dia: String
    let horario: String
    let itemClass: BookingClassItemRequest
    let bookOrCancel: Int
}

struct BookingClassItemRequest: Encodable {
    let id: String
    let name: String
    let coach: String
    let photo: String
    let time: String
    let level: Int
    let agenda: Int
    let total: Int
    let cancelled: Bool
    let isScheduled: Bool

    init(item: ClassItem) {
        self.id = item.id
        self.name = item.name
        self.coach = item.coach
        self.photo = item.photo
        self.time = item.time
        self.level = item.level
        self.agenda = item.agenda
        self.total = item.total
        self.cancelled = item.cancelled
        self.isScheduled = item.isScheduled
    }
}
