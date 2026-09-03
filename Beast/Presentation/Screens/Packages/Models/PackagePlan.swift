import Foundation

struct PackagePlan: Identifiable {
    let id = UUID()
    let badge: String?
    let name: String
    let description: String
    let price: String
    let period: String?
    let imageName: String
    let benefits: [String]
    let footer: String?
}
