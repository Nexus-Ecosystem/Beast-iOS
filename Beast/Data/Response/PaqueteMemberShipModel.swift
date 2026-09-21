import Foundation

struct PaqueteMemberShipModel: Codable, Identifiable, Equatable {

    let idPaquete: String
    let name: String
    let descripcion: String
    let precioRegular: Double
    let precioDescuento: Double
    let beneficios: [String]
    let tipoPaquete: Int
    let imagePlan: String
    let diasVigencia: Int
    let incluyeFinesDeSemana: Bool

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
        tipoPaquete: Int = 0,
        imagePlan: String = "",
        diasVigencia: Int = 0,
        incluyeFinesDeSemana: Bool = false
    ) {
        self.idPaquete = idPaquete
        self.name = name
        self.descripcion = descripcion
        self.precioRegular = precioRegular
        self.precioDescuento = precioDescuento
        self.beneficios = beneficios
        self.tipoPaquete = tipoPaquete
        self.imagePlan = imagePlan
        self.diasVigencia = diasVigencia
        self.incluyeFinesDeSemana = incluyeFinesDeSemana
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        idPaquete = try container.decodeIfPresent(
            String.self,
            forKey: .idPaquete
        ) ?? ""

        name = try container.decodeIfPresent(
            String.self,
            forKey: .name
        ) ?? ""

        descripcion = try container.decodeIfPresent(
            String.self,
            forKey: .descripcion
        ) ?? ""

        precioRegular = Self.decodeDouble(
            from: container,
            key: .precioRegular
        )

        precioDescuento = Self.decodeDouble(
            from: container,
            key: .precioDescuento
        )

        beneficios = try container.decodeIfPresent(
            [String].self,
            forKey: .beneficios
        ) ?? []

        tipoPaquete = Self.decodeInt(
            from: container,
            key: .tipoPaquete
        )

        imagePlan = try container.decodeIfPresent(
            String.self,
            forKey: .imagePlan
        ) ?? ""

        diasVigencia = Self.decodeInt(
            from: container,
            key: .diasVigencia
        )

        incluyeFinesDeSemana = Self.decodeBool(
            from: container,
            key: .incluyeFinesDeSemana
        )
    }

    private static func decodeBool(
        from container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys
    ) -> Bool {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }

        if let value = try? container.decode(Int.self, forKey: key) {
            return value != 0
        }

        if let value = try? container.decode(String.self, forKey: key) {
            switch value
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() {

            case "true", "1", "si", "sí", "yes":
                return true

            default:
                return false
            }
        }

        return false
    }

    private static func decodeInt(
        from container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys
    ) -> Int {
        if let value = try? container.decode(Int.self, forKey: key) {
            return value
        }

        if let value = try? container.decode(Double.self, forKey: key) {
            return Int(value)
        }

        if let value = try? container.decode(String.self, forKey: key) {
            return Int(value) ?? 0
        }

        return 0
    }

    private static func decodeDouble(
        from container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys
    ) -> Double {
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }

        if let value = try? container.decode(Int.self, forKey: key) {
            return Double(value)
        }

        if let value = try? container.decode(String.self, forKey: key) {
            return Double(value) ?? 0
        }

        return 0
    }

    enum CodingKeys: String, CodingKey {
        case idPaquete
        case name
        case descripcion
        case precioRegular
        case precioDescuento
        case beneficios
        case tipoPaquete
        case imagePlan
        case diasVigencia
        case incluyeFinesDeSemana
    }
}
