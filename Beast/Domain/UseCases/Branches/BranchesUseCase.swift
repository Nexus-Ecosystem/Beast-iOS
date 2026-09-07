import Foundation

final class BranchesUseCase {
    private let repository:
        BranchesRepository

    init(
        repository:
            BranchesRepository =
                BranchesRepositoryImpl()
    ) {
        self.repository = repository
    }

    func getAllBranches()
        async throws -> [BranchModel]
    {
        try await repository
            .getAllBranches()
    }

    func subscribe(
        email: String,
        branchId: String
    ) async throws -> Bool {
        try await repository.subscribe(
            email: email,
            branchId: branchId
        )
    }
}
