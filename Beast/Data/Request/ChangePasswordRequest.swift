import Foundation

struct ChangePasswordRequest: Encodable {
    let email: String
    let newPassword: String
}
