import Foundation

protocol NotificationsRepository {
    func getNotifications(
        email: String,
        day: String
    ) async throws -> [NotificationModel]
}
