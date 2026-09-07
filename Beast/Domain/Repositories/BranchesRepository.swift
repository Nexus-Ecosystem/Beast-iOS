import Foundation

protocol BranchesRepository {
    func getAllBranches()
        async throws -> [BranchModel]

    func subscribe(
        email: String,
        branchId: String
    ) async throws -> Bool
}
