import Foundation

struct SendOTPUseCase {

    private let remoteDataSource:
        SendOTPRemoteDataSourceProtocol

    init(
        remoteDataSource:
            SendOTPRemoteDataSourceProtocol =
                SendOTPRemoteDataSource()
    ) {
        self.remoteDataSource =
            remoteDataSource
    }

    func execute(
        email: String
    ) async throws {

        let request =
            SendOTPRequest(
                email: email
            )

        let response =
            try await remoteDataSource
                .sendOTP(
                    request: request
                )

        guard response.success else {
            throw SendOTPRemoteError
                .sendFailed
        }
    }
}
