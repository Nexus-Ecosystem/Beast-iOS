import Foundation

final class DeleteAccountRepositoryImpl: DeleteAccountRepository {
    private let remoteDataSource: DeleteAccountRemoteDataSourceProtocol

    init(
        remoteDataSource: DeleteAccountRemoteDataSourceProtocol = DeleteAccountRemoteDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
    }

    func deleteAccount(
        email: String
    ) async throws {
        let request = DeleteAccountRequest(
            email: email
        )

        try await remoteDataSource.deleteAccount(
            request: request
        )
    }
}
