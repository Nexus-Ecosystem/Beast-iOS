import Foundation

enum ClassItemMapper {
    static func map(
        _ response: ClassItemResponse,
        isScheduled: Bool
    ) -> ClassItem {
        ClassItem(
            id: response.id,
            name: response.name,
            coach: response.coach,
            photo: response.photo,
            time: response.time,
            level: response.level,
            agenda: response.agenda,
            total: response.total,
            cancelled: response.cancelled,
            isScheduled: isScheduled
        )
    }
}
