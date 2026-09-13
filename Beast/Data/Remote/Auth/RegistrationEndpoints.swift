import Foundation

enum RegistrationEndpoints {
    static var sendOtp: String {
        AppConfiguration.serviceURL("sendotp")
    }

    static var verifyOtp: String {
        AppConfiguration.serviceURL("verifyotp")
    }

    static var register: String {
        AppConfiguration.serviceURL("register")
    }

    static var subscribeUserToBranch: String {
        AppConfiguration.serviceURL("subscribeusertobranch")
    }
}
