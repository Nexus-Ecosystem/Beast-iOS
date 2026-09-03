import Foundation

struct CurrentPackageInfo: Codable {
    let idPaquete: String
    let precio: Double
    let clasesTomadas: Int
    let clasesTotales: Int
    let tipoPaquete: Int
    let expiracion: String
    let name: String

    init(
        idPaquete: String = "",
        precio: Double = 0,
        clasesTomadas: Int = 0,
        clasesTotales: Int = 0,
        tipoPaquete: Int = 0,
        expiracion: String = "",
        name: String = ""
    ) {
        self.idPaquete = idPaquete
        self.precio = precio
        self.clasesTomadas = clasesTomadas
        self.clasesTotales = clasesTotales
        self.tipoPaquete = tipoPaquete
        self.expiracion = expiracion
        self.name = name
    }
}
