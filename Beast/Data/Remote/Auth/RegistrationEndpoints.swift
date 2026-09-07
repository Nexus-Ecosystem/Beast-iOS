import Foundation

enum RegistrationEndpoints {
    static let baseURL =
        "https://us-central1-bookings-spinnings.cloudfunctions.net"

    static var sendOtp: String {
        "\(baseURL)/sendOtp"
    }

    static var verifyOtp: String {
        "\(baseURL)/verifyOtp"
    }

    static var register: String {
        "\(baseURL)/register"
    }

    static var subscribeUserToBranch: String {
        "\(baseURL)/subscribeUserToBranch"
    }
}
