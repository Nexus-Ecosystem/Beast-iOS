import Foundation

final class ResponsiveUseCase {
    private let repository:
        ResponsiveRepository

    init(
        repository:
            ResponsiveRepository =
                ResponsiveRepositoryImpl()
    ) {
        self.repository =
            repository
    }

    func signResponsive(
        signatureBase64: String,
        email: String,
        branchId: String
    ) async throws -> ResponsiveResponse {
        try await repository
            .signResponsive(
                signatureBase64:
                    signatureBase64,
                email:
                    email,
                branchId:
                    branchId
            )
    }
}
