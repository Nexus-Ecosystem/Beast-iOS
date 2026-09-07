import Foundation

struct VerifyOtpRequest: Encodable {
    let email: String
    let otp: String
}
