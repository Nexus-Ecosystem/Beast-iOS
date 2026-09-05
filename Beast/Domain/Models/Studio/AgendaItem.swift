import Foundation

struct AgendaItem: Codable, Identifiable, Equatable {
    let id: String
    let correo: String
    let asignacionMobiliario: String

    init(
        id: String = UUID().uuidString,
        correo: String = "",
        asignacionMobiliario: String = ""
    ) {
        self.id = id
        self.correo = correo
        self.asignacionMobiliario = asignacionMobiliario
    }
}
