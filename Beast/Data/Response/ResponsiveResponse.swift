import Foundation

struct ResponsiveResponse: Decodable {
    let success: Bool
    let url: String
    let error: String

    enum CodingKeys: String, CodingKey {
        case success
        case url
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        success = try container.decodeIfPresent(
            Bool.self,
            forKey: .success
        ) ?? false

        url = try container.decodeIfPresent(
            String.self,
            forKey: .url
        ) ?? ""

        error = try container.decodeIfPresent(
            String.self,
            forKey: .error
        ) ?? ""
    }
}
