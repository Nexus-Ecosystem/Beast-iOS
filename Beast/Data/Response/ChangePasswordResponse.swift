import Foundation

struct ChangePasswordResponse: Decodable {
    let ok: Bool
    let error: String

    enum CodingKeys: String, CodingKey {
        case ok
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        ok = try container.decodeIfPresent(
            Bool.self,
            forKey: .ok
        ) ?? false

        error = try container.decodeIfPresent(
            String.self,
            forKey: .error
        ) ?? ""
    }
}
