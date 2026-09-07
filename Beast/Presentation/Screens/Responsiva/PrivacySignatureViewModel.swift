import Foundation
import Combine
import UIKit

@MainActor
final class PrivacySignatureViewModel:
    ObservableObject
{
    @Published private(set)
    var isLoading = false

    @Published private(set)
    var successMessage = ""

    @Published private(set)
    var errorMessage = ""

    @Published
    var showSuccess = false

    @Published
    var showError = false

    private let responsiveUseCase:
        ResponsiveUseCase

    private let profileUseCase:
        ProfileUseCase

    init(
        responsiveUseCase:
            ResponsiveUseCase =
                ResponsiveUseCase(),
        profileUseCase:
            ProfileUseCase =
                ProfileUseCase()
    ) {
        self.responsiveUseCase =
            responsiveUseCase

        self.profileUseCase =
            profileUseCase
    }

    func sign(
        image: UIImage
    ) async {
        guard !isLoading else {
            return
        }

        guard let profile =
            profileUseCase.localProfile()
        else {
            presentError(
                "No se encontró la información del usuario."
            )
            return
        }

        let email =
            profile.email
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        guard !email.isEmpty else {
            presentError(
                "No se encontró el correo del usuario."
            )
            return
        }

        guard
            let branch =
                profile.branches.first
        else {
            presentError(
                "No se encontró la sucursal del usuario."
            )
            return
        }

        let branchId =
            String(
                describing: branch
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !branchId.isEmpty else {
            presentError(
                "La sucursal del usuario no es válida."
            )
            return
        }

        guard
            let imageData =
                image.pngData()
        else {
            presentError(
                "No fue posible procesar la firma."
            )
            return
        }

        let signatureBase64 =
            imageData
                .base64EncodedString()

        guard !signatureBase64.isEmpty else {
            presentError(
                "La firma está vacía."
            )
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            let response =
                try await responsiveUseCase
                    .signResponsive(
                        signatureBase64:
                            signatureBase64,
                        email:
                            email,
                        branchId:
                            branchId
                    )

            guard response.success else {
                presentError(
                    response.error.isEmpty
                        ? "No fue posible firmar la responsiva."
                        : response.error
                )
                return
            }

            successMessage =
                "Responsiva firmada con éxito."

            showSuccess = true

        } catch {
            presentError(
                error.localizedDescription
            )
        }
    }

    func closeSuccess() {
        showSuccess = false
    }

    func closeError() {
        showError = false
    }

    private func presentError(
        _ message: String
    ) {
        errorMessage =
            message

        showError =
            true
    }
}
