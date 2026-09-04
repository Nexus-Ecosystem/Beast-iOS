import Foundation

protocol BookingRepository {
    func bookingClass(
        request: BookingClassRequest
    ) async throws -> BookingClassResponse
}
