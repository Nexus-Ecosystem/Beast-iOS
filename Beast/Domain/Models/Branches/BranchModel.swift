import Foundation

struct BranchModel:
    Identifiable,
    Hashable
{
    let idBranch: String
    let name: String
    let address: String
    let phone: String
    let email: String
    let rating: Double
    let gallery: [String]

    var id: String {
        idBranch
    }

    static let empty = BranchModel(
        idBranch: "",
        name: "",
        address: "",
        phone: "",
        email: "",
        rating: 0,
        gallery: []
    )
}
