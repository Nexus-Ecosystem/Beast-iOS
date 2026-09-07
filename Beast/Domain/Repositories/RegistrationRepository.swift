import Foundation

protocol RegistrationRepository {
    func sendOtp(
        email: String
    ) async throws -> Bool

    func verifyOtp(
        email: String,
        otp: String
    ) async throws -> Bool

    func register(
        user: RegistrationUser,
        tokenFirebase: String
    ) async throws -> RegisterResponse
}
