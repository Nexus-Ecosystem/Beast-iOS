import Foundation

extension LoginResponse {
    func toDomain() -> AllDataProfileUserSystem {
        AllDataProfileUserSystem(
            typeUser: typeUser,
            fechaPago: fechaPago,
            fotoPerfil: fotoPerfil,
            branches: brancheInUser,
            createdAt: createdAt,
            fullName: fullName,
            phone: phone,
            email: email,
            membershipName: memberShipName,
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
