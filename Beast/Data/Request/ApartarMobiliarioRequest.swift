import Foundation

struct ApartarMobiliarioRequest: Encodable {
    let numMobiliario: String
    let idSucursal: String
    let email: String
    let mes: String
    let dia: String
    let hora: String

    enum CodingKeys: String, CodingKey {
        case numMobiliario
        case idSucursal = "idBranch"
        case email = "mailAlumno"
        case mes
        case dia
        case hora
    }
}
