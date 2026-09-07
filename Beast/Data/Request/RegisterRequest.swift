import Foundation

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let fullName: String
    let phone: String
    let tokenFirebase: String
}
