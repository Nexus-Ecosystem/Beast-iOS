import Foundation

final class NotificationsUseCase {
    private let repository:
        NotificationsRepository

    init(
        repository:
            NotificationsRepository =
                NotificationsRepositoryImpl()
    ) {
        self.repository =
            repository
    }

    func getNotifications(
        email: String,
        day: String
    ) async throws -> [NotificationModel] {
        try await repository
            .getNotifications(
                email: email,
                day: day
            )
    }
}
