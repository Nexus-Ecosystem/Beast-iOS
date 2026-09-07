import Foundation

final class RegistrationRepositoryImpl:
    RegistrationRepository
{
    private let remoteDataSource:
        RegistrationRemoteDataSourceProtocol

    init(
        remoteDataSource:
            RegistrationRemoteDataSourceProtocol =
                RegistrationRemoteDataSource()
    ) {
        self.remoteDataSource =
            remoteDataSource
    }

    func sendOtp(
        email: String
    ) async throws -> Bool {
        let response =
            try await remoteDataSource.sendOtp(
                request:
                    SendOtpRequest(
                        email: email
                    )
            )

        if !response.success,
           !response.error.isEmpty {
            throw RegistrationRepositoryError.backend(
                response.error
            )
        }

        return response.success
    }

    func verifyOtp(
        email: String,
        otp: String
    ) async throws -> Bool {
        let response =
            try await remoteDataSource.verifyOtp(
                request:
                    VerifyOtpRequest(
                        email: email,
                        otp: otp
                    )
            )

        if !response.verified,
           !response.error.isEmpty {
            throw RegistrationRepositoryError.backend(
                response.error
            )
        }

        return response.verified
    }

    func register(
        user: RegistrationUser,
        tokenFirebase: String
    ) async throws -> RegisterResponse {
        try await remoteDataSource.register(
            request:
                RegisterRequest(
                    email: user.email,
                    password: user.password,
                    fullName: user.fullName,
                    phone: user.phone,
                    tokenFirebase:
                        tokenFirebase
                )
        )
    }
}

enum RegistrationRepositoryError:
    LocalizedError
{
    case backend(String)

    var errorDescription: String? {
        switch self {
        case let .backend(message):
            return message
        }
    }
}
