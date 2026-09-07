import Foundation

final class NotificationsRepositoryImpl:
    NotificationsRepository
{
    private let remoteDataSource:
        NotificationsRemoteDataSourceProtocol

    init(
        remoteDataSource:
            NotificationsRemoteDataSourceProtocol =
                NotificationsRemoteDataSource()
    ) {
        self.remoteDataSource =
            remoteDataSource
    }

    func getNotifications(
        email: String,
        day: String
    ) async throws -> [NotificationModel] {
        let request =
            NotificationsRequest(
                email: email,
                read: true,
                day: day
            )

        let response =
            try await remoteDataSource
                .getNotifications(
                    request: request
                )

        return response
            .notifications
            .map {
                $0.toDomain()
            }
    }
}
