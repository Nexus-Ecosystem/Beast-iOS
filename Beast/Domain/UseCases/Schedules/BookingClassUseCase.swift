import Foundation

final class BookingClassUseCase {
    private let repository: BookingRepository

    init(
        repository: BookingRepository = BookingRepositoryImpl()
    ) {
        self.repository = repository
    }

    func execute(
        branch: String,
        date: String,
        item: ClassItem,
        profile: AllDataProfileUserSystem,
        action: BookingAction
    ) async throws -> BookingClassResponse {
        let request = BookingClassRequest(
            correo: profile.email,
            nombre: profile.fullName,
            telefono: profile.phone,
            idSucursal: branch,
            dia: date,
            horario: item.time,
            itemClass: BookingClassItemRequest(
                item: item
            ),
            bookOrCancel: action.rawValue
        )

        return try await repository.bookingClass(
            request: request
        )
    }
}

enum BookingAction: Int {
    case book = 1
    case cancel = 2
}
