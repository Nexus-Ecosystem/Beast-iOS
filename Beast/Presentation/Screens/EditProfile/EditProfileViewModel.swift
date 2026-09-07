import Foundation
import UIKit
import Combine

@MainActor
final class EditProfileViewModel:
    ObservableObject
{
    @Published var fullName = ""
    @Published var phone = ""

    @Published private(set) var email = ""
    @Published private(set) var memberId = ""
    @Published private(set) var createdAt = ""
    @Published private(set) var packageName = ""
    @Published private(set) var profileImageURL = ""

    @Published private(set)
    var selectedImageData: Data?

    @Published private(set)
    var isLoading = false

    @Published var showSuccess = false
    @Published var showError = false
    @Published var message = ""

    private let profileUseCase:
        ProfileUseCase

    private let editUseCase:
        ProfileEditUseCase

    init(
        profileUseCase:
            ProfileUseCase =
                ProfileUseCase(),
        editUseCase:
            ProfileEditUseCase =
                ProfileEditUseCase()
    ) {
        self.profileUseCase =
            profileUseCase

        self.editUseCase =
            editUseCase
    }

    var canSave: Bool {
        !fullName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty &&
        !phone
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
    }

    var selectedUIImage: UIImage? {
        guard let selectedImageData else {
            return nil
        }

        return UIImage(
            data: selectedImageData
        )
    }

    func load() {
        guard let profile =
            profileUseCase.localProfile()
        else {
            message =
                "No se encontró la información del usuario."

            showError = true
            return
        }

        fullName =
            profile.fullName

        phone =
            profile.phone

        email =
            profile.email

        memberId =
            profile.idSocio

        createdAt =
            profile.createdAt

        packageName =
            profile.activePackage.name

        profileImageURL =
            profile.fotoPerfil
    }

    func setImage(
        _ data: Data
    ) {
        guard let image =
            UIImage(
                data: data
            )
        else {
            return
        }

        selectedImageData =
            image.jpegData(
                compressionQuality: 0.82
            )
    }

    func save() async {
        guard canSave else {
            message =
                "Ingresa tu nombre y teléfono."

            showError = true
            return
        }

        guard !email.isEmpty else {
            message =
                "No se encontró el correo del usuario."

            showError = true
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            try await editUseCase
                .updateProfile(
                    email: email,
                    fullName:
                        fullName
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            ),
                    phone:
                        phone
                            .trimmingCharacters(
                                in:
                                    .whitespacesAndNewlines
                            )
                )

            if let selectedImageData {
                let imageURL =
                    try await editUseCase
                        .uploadProfileImage(
                            email: email,
                            imageData:
                                selectedImageData
                        )

                try await editUseCase
                    .updateProfileImage(
                        email: email,
                        imageURL: imageURL
                    )

                profileImageURL =
                    imageURL
            }

            message =
                "Tu perfil se actualizó correctamente."

            showSuccess = true

        } catch {
            message =
                error.localizedDescription

            showError = true
        }
    }

    func closeSuccess() {
        showSuccess = false
    }

    func closeError() {
        showError = false
    }
}
