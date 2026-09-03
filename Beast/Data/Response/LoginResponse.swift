import Foundation

struct LoginResponse: Decodable {
    let typeUser: Int
    let fechaPago: String
    let fotoPerfil: String
    let brancheInUser: [String]
    let createdAt: String
    let fullName: String
    let phone: String
    let email: String
    let memberShipName: String
    let urlPhoto: String
    let idSocio: String
    let nipSocio: String
    let status: Int
    let responsiveSigned: Bool
    let urlDocumentResponsiva: String
    let tokenFirebase: String
    let activePackage: CurrentPackageInfo
    let historyClasses: [ClassHistory]
    let historyPayments: [PaymentHistory]

    enum CodingKeys: String, CodingKey {
        case typeUser
        case fechaPago
        case fotoPerfil
        case brancheInUser
        case createdAt
        case fullName
        case phone
        case email
        case memberShipName
        case urlPhoto
        case idSocio
        case nipSocio
        case status
        case responsiveSigned
        case urlDocumentResponsiva
        case tokenFirebase
        case activePackage
        case historyClasses
        case historyPayments
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        typeUser = try container.decodeIfPresent(Int.self, forKey: .typeUser) ?? 1
        fechaPago = try container.decodeIfPresent(String.self, forKey: .fechaPago) ?? ""
        fotoPerfil = try container.decodeIfPresent(String.self, forKey: .fotoPerfil) ?? ""
        brancheInUser = try container.decodeIfPresent([String].self, forKey: .brancheInUser) ?? []
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        memberShipName = try container.decodeIfPresent(String.self, forKey: .memberShipName) ?? ""
        urlPhoto = try container.decodeIfPresent(String.self, forKey: .urlPhoto) ?? ""
        idSocio = try container.decodeIfPresent(String.self, forKey: .idSocio) ?? ""
        nipSocio = try container.decodeIfPresent(String.self, forKey: .nipSocio) ?? ""
        status = try container.decodeIfPresent(Int.self, forKey: .status) ?? 0
        responsiveSigned = try container.decodeIfPresent(Bool.self, forKey: .responsiveSigned) ?? false
        urlDocumentResponsiva = try container.decodeIfPresent(String.self, forKey: .urlDocumentResponsiva) ?? ""
        tokenFirebase = try container.decodeIfPresent(String.self, forKey: .tokenFirebase) ?? ""
        activePackage = try container.decodeIfPresent(CurrentPackageInfo.self, forKey: .activePackage) ?? CurrentPackageInfo()
        historyClasses = try container.decodeIfPresent([ClassHistory].self, forKey: .historyClasses) ?? []
        historyPayments = try container.decodeIfPresent([PaymentHistory].self, forKey: .historyPayments) ?? []
    }
}
