import Foundation

struct SendOtpResponse: Decodable {
    let success: Bool
    let error: String

    enum CodingKeys: String, CodingKey {
        case success
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

        error = try container.decodeIfPresent(
            String.self,
            forKey: .error
        ) ?? ""
    }
}
