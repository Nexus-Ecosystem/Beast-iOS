import Foundation

struct RegisterUserToBranchRequest: Encodable {
    let email: String
    let idBranch: String

    enum CodingKeys: String, CodingKey {
        case email
        case idBranch = "branchId"
    }
}
