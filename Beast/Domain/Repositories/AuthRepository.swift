import Foundation

protocol AuthRepository {
    func login(
        email: String,
        password: String,
        tokenFirebase: String
    ) async throws -> LoginResponse
}
