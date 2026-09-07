import Foundation

protocol ResponsiveRepository {
    func signResponsive(
        signatureBase64: String,
        email: String,
        branchId: String
    ) async throws -> ResponsiveResponse
}
