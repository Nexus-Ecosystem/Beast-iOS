import Foundation

final class ResponsiveRepositoryImpl:
    ResponsiveRepository
{
    private let remoteDataSource:
        ResponsiveRemoteDataSourceProtocol

    init(
        remoteDataSource:
            ResponsiveRemoteDataSourceProtocol =
                ResponsiveRemoteDataSource()
    ) {
        self.remoteDataSource =
            remoteDataSource
    }

    func signResponsive(
        signatureBase64: String,
        email: String,
        branchId: String
    ) async throws -> ResponsiveResponse {
        let request =
            ResponsiveRequest(
                signatureBase64:
                    signatureBase64,
                email:
                    email,
                branchId:
                    branchId
            )

        return try await remoteDataSource
            .signResponsive(
                request: request
            )
    }
}
