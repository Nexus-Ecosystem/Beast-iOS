import Foundation

enum PackageMockData {

    static let popularPackage = PackagePlan(
        badge: "MÁS POPULAR",
        name: "AVANZA",
        description: "Membresía mensual para entrenar sin límites",
        price: "$800",
        period: "mes",
        imageName: "package_1",
        benefits: [
            "Acceso completo al gimnasio",
            "Cancela cuando quieras",
            "Seguimiento básico incluido"
        ],
        footer: "Cancelación flexible con aviso de 30 días."
    )

    static let specialPackages: [PackagePlan] = [
        .init(
            badge: "ENTRADA",
            name: "6 clases",
            description: "Ideal para comenzar",
            price: "$200",
            period: nil,
            imageName: "package_1",
            benefits: [],
            footer: nil
        ),
        .init(
            badge: "PREMIUM",
            name: "10 clases",
            description: "Para entrenar constante",
            price: "$300",
            period: nil,
            imageName: "package_1",
            benefits: [],
            footer: nil
        ),
        .init(
            badge: "PLATINO",
            name: "15 clases",
            description: "Mayor avance mensual",
            price: "$550",
            period: nil,
            imageName: "package_1",
            benefits: [],
            footer: nil
        ),
        .init(
            badge: "ALTO RENDIMIENTO",
            name: "20 clases",
            description: "Para metas exigentes",
            price: "$700",
            period: nil,
            imageName: "package_1",
            benefits: [],
            footer: nil
        )
    ]
}
