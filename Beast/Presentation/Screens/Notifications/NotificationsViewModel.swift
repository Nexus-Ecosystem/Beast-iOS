import Foundation
import Combine

@MainActor
final class NotificationsViewModel:
    ObservableObject
{
    @Published private(set)
    var notifications:
        [NotificationModel] = []

    @Published private(set)
    var isLoading = false

    @Published private(set)
    var errorMessage = ""

    @Published
    var showError = false

    private let notificationsUseCase:
        NotificationsUseCase

    private let profileUseCase:
        ProfileUseCase

    init(
        notificationsUseCase:
            NotificationsUseCase =
                NotificationsUseCase(),
        profileUseCase:
            ProfileUseCase =
                ProfileUseCase()
    ) {
        self.notificationsUseCase =
            notificationsUseCase

        self.profileUseCase =
            profileUseCase
    }

    func load() async {
        guard !isLoading else {
            return
        }

        guard let profile =
            profileUseCase.localProfile()
        else {
            errorMessage =
                "No se encontró la información del usuario."

            showError = true
            return
        }

        let email =
            profile.email
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard !email.isEmpty else {
            errorMessage =
                "No se encontró el correo del usuario."

            showError = true
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            notifications =
                try await notificationsUseCase
                    .getNotifications(
                        email: email,
                        day: Self.currentDay
                    )
        } catch {
            errorMessage =
                error.localizedDescription

            showError = true
        }
    }

    func closeError() {
        showError = false
    }

    private static var currentDay:
        String
    {
        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(
                identifier:
                    "en_US_POSIX"
            )

        formatter.calendar =
            Calendar(
                identifier:
                    .gregorian
            )

        formatter.dateFormat =
            "yyyy-MM-dd"

        return formatter.string(
            from: Date()
        )
    }
}
