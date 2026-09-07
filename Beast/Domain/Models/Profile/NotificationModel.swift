import Foundation

struct NotificationModel: Identifiable, Equatable {
    let id: String
    let type: Int
    let title: String
    let body: String
    let timestamp: String
    let read: Bool
}
