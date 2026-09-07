import Foundation

final class BranchesRepositoryImpl:
    BranchesRepository
{
    private let firebase:
        BranchesFirebaseDataSourceProtocol

    private let remote:
        BranchesRemoteDataSourceProtocol

    init(
        firebase:
            BranchesFirebaseDataSourceProtocol =
                BranchesFirebaseDataSource(),
        remote:
            BranchesRemoteDataSourceProtocol =
                BranchesRemoteDataSource()
    ) {
        self.firebase = firebase
        self.remote = remote
    }

    func getAllBranches()
        async throws -> [BranchModel]
    {
        try await firebase
            .getAllBranches()
    }

    func subscribe(
        email: String,
        branchId: String
    ) async throws -> Bool {
        try await remote.subscribe(
            email: email,
            branchId: branchId
        )
    }
}
