import Foundation

struct NotificationsRequest: Encodable {
    let email: String
    let read: Bool
    let day: String
}
