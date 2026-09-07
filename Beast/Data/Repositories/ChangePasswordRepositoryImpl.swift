import Foundation

final class ChangePasswordRepositoryImpl:
    ChangePasswordRepository
{
    private let remoteDataSource:
        ChangePasswordRemoteDataSourceProtocol

    init(
        remoteDataSource:
            ChangePasswordRemoteDataSourceProtocol =
                ChangePasswordRemoteDataSource()
    ) {
        self.remoteDataSource =
            remoteDataSource
    }

    func changePassword(
        email: String,
        newPassword: String
    ) async throws -> Bool {
        let request = ChangePasswordRequest(
            email: email,
            newPassword: newPassword
        )

        let response =
            try await remoteDataSource.changePassword(
                request: request
            )

        if !response.ok,
           !response.error.isEmpty {
            throw ChangePasswordRepositoryError.backend(
                response.error
            )
        }

        return response.ok
    }
}

enum ChangePasswordRepositoryError:
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
