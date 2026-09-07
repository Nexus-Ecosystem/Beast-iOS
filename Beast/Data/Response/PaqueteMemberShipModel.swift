import Foundation

struct PaqueteMemberShipModel: Codable, Identifiable, Equatable {
    let idPaquete: String
    let name: String
    let descripcion: String
    let precioRegular: Double
    let precioDescuento: Double
    let beneficios: [String]
    let tipoPaquete: Int

    var id: String {
        idPaquete
    }

    init(
        idPaquete: String = "",
        name: String = "",
        descripcion: String = "",
        precioRegular: Double = 0,
        precioDescuento: Double = 0,
        beneficios: [String] = [],
        tipoPaquete: Int = 0
    ) {
        self.idPaquete = idPaquete
        self.name = name
        self.descripcion = descripcion
        self.precioRegular = precioRegular
        self.precioDescuento = precioDescuento
        self.beneficios = beneficios
        self.tipoPaquete = tipoPaquete
    }

    enum CodingKeys: String, CodingKey {
        case idPaquete
        case name
        case descripcion
        case precioRegular
        case precioDescuento
        case beneficios
        case tipoPaquete
    }
}
