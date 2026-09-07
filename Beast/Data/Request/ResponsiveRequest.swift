import Foundation

struct ResponsiveRequest: Encodable {
    let signatureBase64: String
    let email: String
    let branchId: String
}
