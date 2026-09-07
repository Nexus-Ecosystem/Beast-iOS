import Foundation

struct AllDataProfileUserSystem: Codable {
    let typeUser: Int
    let fechaPago: String
    let fotoPerfil: String
    let branches: [String]
    let createdAt: String
    let fullName: String
    let phone: String
    let email: String
    let membershipName: String
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

    func withBranches(
        _ branches: [String]
    ) -> AllDataProfileUserSystem {
        AllDataProfileUserSystem(
            typeUser: typeUser,
            fechaPago: fechaPago,
            fotoPerfil: fotoPerfil,
            branches: branches,
            createdAt: createdAt,
            fullName: fullName,
            phone: phone,
            email: email,
            membershipName: membershipName,
            urlPhoto: urlPhoto,
            idSocio: idSocio,
            nipSocio: nipSocio,
            status: status,
            responsiveSigned: responsiveSigned,
            urlDocumentResponsiva: urlDocumentResponsiva,
            tokenFirebase: tokenFirebase,
            activePackage: activePackage,
            historyClasses: historyClasses,
            historyPayments: historyPayments
        )
    }
}
