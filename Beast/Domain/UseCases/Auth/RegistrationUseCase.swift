import Foundation

final class RegistrationUseCase {
    private let repository:
        RegistrationRepository

    init(
        repository:
            RegistrationRepository =
                RegistrationRepositoryImpl()
    ) {
        self.repository =
            repository
    }

    func sendOtp(
        email: String
    ) async throws -> Bool {
        try await repository.sendOtp(
            email: email
        )
    }

    func verifyOtp(
        email: String,
        otp: String
    ) async throws -> Bool {
        try await repository.verifyOtp(
            email: email,
            otp: otp
        )
    }

    func register(
        user: RegistrationUser
    ) async throws -> RegisterResponse {
        let tokenFirebase =
            UserDefaults.standard.string(
                forKey: "BEASTTOKEN"
            ) ?? ""

        return try await repository.register(
            user: user,
            tokenFirebase: tokenFirebase
        )
    }
}
