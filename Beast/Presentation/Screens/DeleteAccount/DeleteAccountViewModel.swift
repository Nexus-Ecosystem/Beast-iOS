import Foundation
import Combine

@MainActor
final class DeleteAccountViewModel: ObservableObject {
    @Published var confirmationText = ""
    @Published var hasAcceptedConsequences = false

    @Published private(set) var isLoading = false
    @Published var showError = false
    @Published private(set) var errorMessage = ""

    private let email: String
    private let useCase: DeleteAccountUseCaseProtocol

    init(
        email: String,
        useCase: DeleteAccountUseCaseProtocol = DeleteAccountUseCase()
    ) {
        self.email = email
        self.useCase = useCase
    }

    var isConfirmationValid: Bool {
        confirmationText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased() == "ELIMINAR"
    }

    var canDelete: Bool {
        isConfirmationValid &&
        hasAcceptedConsequences &&
        !isLoading
    }

    func deleteAccount(
        onSuccess: @escaping () -> Void
    ) async {
        guard canDelete else {
            return
        }

        isLoading = true
        errorMessage = ""

        do {
            try await useCase.execute(
                email: email
            )

            isLoading = false
            onSuccess()
        } catch {
            isLoading = false
            errorMessage =
                error.localizedDescription.isEmpty
                ? "No fue posible eliminar tu cuenta. Inténtalo nuevamente."
                : error.localizedDescription

            showError = true
        }
    }

    func closeError() {
        showError = false
        errorMessage = ""
    }
}
