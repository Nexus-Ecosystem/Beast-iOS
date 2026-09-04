import Foundation

final class BookingRepositoryImpl: BookingRepository {
    private let remoteDataSource: BookingRemoteDataSourceProtocol

    init(
        remoteDataSource: BookingRemoteDataSourceProtocol = BookingRemoteDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
    }

    func bookingClass(
        request: BookingClassRequest
    ) async throws -> BookingClassResponse {
        try await remoteDataSource.bookingClass(
            request: request
        )
    }
}
