import Foundation

struct NotificationsResponse: Decodable {
    let notifications: [InfoNotificationResponse]

    private enum CodingKeys: String, CodingKey {
        case notifications
        case data
        case result
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let list = try? container.decode([InfoNotificationResponse].self) {
            notifications = list
            return
        }

        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        if let list = try container.decodeIfPresent(
            [InfoNotificationResponse].self,
            forKey: .notifications
        ) {
            notifications = list
            return
        }

        if let list = try container.decodeIfPresent(
            [InfoNotificationResponse].self,
            forKey: .data
        ) {
            notifications = list
            return
        }

        if let list = try container.decodeIfPresent(
            [InfoNotificationResponse].self,
            forKey: .result
        ) {
            notifications = list
            return
        }

        notifications = []
    }
}

struct InfoNotificationResponse: Decodable {
    let id: String
    let type: Int
    let title: String
    let body: String
    let timestamp: String
    let read: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case body
        case timestamp
        case read
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        id = try container.decodeIfPresent(
            String.self,
            forKey: .id
        ) ?? UUID().uuidString

        if let intValue = try? container.decode(
            Int.self,
            forKey: .type
        ) {
            type = intValue
        } else if let stringValue = try? container.decode(
            String.self,
            forKey: .type
        ) {
            type = Int(stringValue) ?? 0
        } else {
            type = 0
        }

        title = try container.decodeIfPresent(
            String.self,
            forKey: .title
        ) ?? ""

        body = try container.decodeIfPresent(
            String.self,
            forKey: .body
        ) ?? ""

        timestamp = try container.decodeIfPresent(
            String.self,
            forKey: .timestamp
        ) ?? ""

        read = try container.decodeIfPresent(
            Bool.self,
            forKey: .read
        ) ?? false
    }

    func toDomain() -> NotificationModel {
        NotificationModel(
            id: id,
            type: type,
            title: title,
            body: body,
            timestamp: timestamp,
            read: read
        )
    }
}
