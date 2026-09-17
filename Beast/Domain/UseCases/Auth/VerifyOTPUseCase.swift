import Foundation

struct VerifyOTPUseCase {

    private let remoteDataSource:
        VerifyOTPRemoteDataSourceProtocol

    init(
        remoteDataSource:
            VerifyOTPRemoteDataSourceProtocol =
                VerifyOTPRemoteDataSource()
    ) {
        self.remoteDataSource =
            remoteDataSource
    }

    func execute(
        email: String,
        otp: String
    ) async throws {

        let request =
            VerifyOTPRequest(
                email: email,
                otp: otp
            )

        let response =
            try await remoteDataSource
                .verifyOTP(
                    request: request
                )

        guard response.verified else {
            throw VerifyOTPRemoteError
                .invalidOTP
        }
    }
}
