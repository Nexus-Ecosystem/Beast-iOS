import Foundation

struct RegisterResponse: Decodable {
    let email: String
    let error: String

    enum CodingKeys: String, CodingKey {
        case email
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        email = try container.decodeIfPresent(
            String.self,
            forKey: .email
        ) ?? ""

        error = try container.decodeIfPresent(
            String.self,
            forKey: .error
        ) ?? ""
    }
}
