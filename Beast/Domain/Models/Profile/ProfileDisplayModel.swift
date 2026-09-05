import Foundation

struct ProfileDisplayModel: Equatable {
    let fullName: String
    let email: String
    let phone: String
    let photoURL: String

    let packageId: String
    let packageName: String
    let packageExpiration: String
    let packageType: Int
    let classesTaken: Int
    let totalClasses: Int
    let extraCredits: Int

    let responsiveSigned: Bool
    let responsiveURL: String

    var hasActivePackage: Bool {
        !packageId.isEmpty &&
        packageId != "-"
    }

    var isMonthlyPackage: Bool {
        packageType == 1
    }

    var packageDisplayName: String {
        guard !packageName.isEmpty else {
            return "Sin nombre"
        }

        return isMonthlyPackage
        ? "\(packageName) (Mensual)"
        : "\(packageName) (Paquete)"
    }

    var classesDescription: String {
        if isMonthlyPackage {
            return "Mensual"
        }

        return "Clases: \(classesTaken)/\(totalClasses)"
    }

    var classProgress: Double {
        guard
            !isMonthlyPackage,
            totalClasses > 0
        else {
            return 0
        }

        return min(
            Double(classesTaken) /
            Double(totalClasses),
            1
        )
    }

    static let empty = ProfileDisplayModel(
        fullName: "",
        email: "",
        phone: "",
        photoURL: "",
        packageId: "",
        packageName: "",
        packageExpiration: "",
        packageType: 0,
        classesTaken: 0,
        totalClasses: 0,
        extraCredits: 0,
        responsiveSigned: false,
        responsiveURL: ""
    )
}
