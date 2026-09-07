import Foundation
import Combine

@MainActor
final class FindBranchViewModel: ObservableObject {
    @Published private(set) var branches: [BranchModel] = []
    @Published var query = ""
    @Published var selectedBranch: BranchModel?
    @Published var showConfirmation = false
    @Published var showError = false
    @Published var showSubscriptionSuccess = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var isLoading = false

    private let registrationEmail: String?
    private let useCase: BranchesUseCase
    private let profileUseCase: ProfileUseCase
    private let storage: AppStorageManager

    init(
        registrationEmail: String? = nil,
        useCase: BranchesUseCase = BranchesUseCase(),
        profileUseCase: ProfileUseCase = ProfileUseCase(),
        storage: AppStorageManager = .shared
    ) {
        self.registrationEmail = registrationEmail
        self.useCase = useCase
        self.profileUseCase = profileUseCase
        self.storage = storage
    }

    var filteredBranches: [BranchModel] {
        let cleanQuery = query
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !cleanQuery.isEmpty else {
            return branches
        }

        return branches.filter {
            $0.name.localizedCaseInsensitiveContains(
                cleanQuery
            )
        }
    }

    func load() async {
        guard !isLoading else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            branches = try await useCase
                .getAllBranches()
        } catch {
            presentError(
                error.localizedDescription
            )
        }
    }

    func select(
        _ branch: BranchModel
    ) {
        selectedBranch = branch
        showConfirmation = true
    }

    func cancelSelection() {
        showConfirmation = false
        selectedBranch = nil
    }

    func subscribe() async {
        guard !isLoading else {
            return
        }

        guard let branch = selectedBranch else {
            return
        }

        guard let email = resolveEmail() else {
            presentError(
                "No se encontró la información del usuario."
            )
            return
        }

        showConfirmation = false
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let success = try await useCase.subscribe(
                email: email,
                branchId: branch.idBranch
            )

            guard success else {
                presentError(
                    "No fue posible suscribirse al estudio."
                )
                return
            }

            updateLocalBranchIfPossible(
                branch.idBranch
            )

            showSubscriptionSuccess = true

        } catch {
            let message =
                error.localizedDescription

            if isAlreadySubscribed(
                message
            ) {
                updateLocalBranchIfPossible(
                    branch.idBranch
                )

                showSubscriptionSuccess = true
                return
            }

            presentError(
                message
            )
        }
    }

    private func resolveEmail() -> String? {
        if let registrationEmail {
            let cleanEmail =
                registrationEmail
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

            if !cleanEmail.isEmpty {
                return cleanEmail
            }
        }

        if let profile =
            profileUseCase.localProfile()
        {
            let cleanEmail =
                profile.email
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

            if !cleanEmail.isEmpty {
                return cleanEmail
            }
        }

        return nil
    }

    private func updateLocalBranchIfPossible(
        _ branchId: String
    ) {
        guard let profile =
            storage.getProfile()
        else {
            return
        }

        var updatedBranches =
            profile.branches

        if !updatedBranches.contains(
            branchId
        ) {
            updatedBranches.append(
                branchId
            )
        }

        let updatedProfile =
            profile.withBranches(
                updatedBranches
            )

        storage.saveProfile(
            updatedProfile
        )

        NotificationCenter.default.post(
            name: .sessionDidChange,
            object: nil
        )
    }

    private func isAlreadySubscribed(
        _ message: String
    ) -> Bool {
        let normalized =
            message
                .folding(
                    options: [
                        .diacriticInsensitive,
                        .caseInsensitive
                    ],
                    locale: .current
                )
                .lowercased()

        return normalized.contains(
            "ya esta suscrito"
        )
    }

    func closeError() {
        showError = false
        errorMessage = ""
    }

    func closeSubscriptionSuccess() {
        showSubscriptionSuccess = false
    }

    private func presentError(
        _ message: String
    ) {
        errorMessage = message
        showError = true
    }
}
