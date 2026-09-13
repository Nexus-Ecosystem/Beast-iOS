import Foundation

enum RegistrationEndpoints {
    private static var baseURL: String {
        AppConfiguration.baseURL
    }

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
