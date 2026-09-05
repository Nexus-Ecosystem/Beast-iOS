import Foundation
import FirebaseFirestore

protocol ProfileFirebaseDataSourceProtocol {
    func observeProfile(
        email: String,
        onChange: @escaping (ProfileDisplayModel) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration
}

final class ProfileFirebaseDataSource: ProfileFirebaseDataSourceProtocol {
    private let firestore: Firestore

    init(
        firestore: Firestore = Firestore.firestore()
    ) {
        self.firestore = firestore
    }

    func observeProfile(
        email: String,
        onChange: @escaping (ProfileDisplayModel) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        let path = "users/\(email)"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "LISTEN"
        )

        return firestore
            .collection("users")
            .document(email)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else {
                    return
                }

                if let error {
                    NetworkLogger.logFirebaseError(
                        path: path,
                        error: error
                    )

                    onError(error)
                    return
                }

                guard
                    let snapshot,
                    snapshot.exists
                else {
                    onChange(.empty)
                    return
                }

                let data = snapshot.data() ?? [:]

                NetworkLogger.logFirebaseResponse(
                    path: path,
                    document: data
                )

                onChange(
                    self.mapProfile(
                        data: data
                    )
                )
            }
    }

    private func mapProfile(
        data: [String: Any]
    ) -> ProfileDisplayModel {
        let package =
            data["activePackage"] as? [String: Any] ??
            [:]

        return ProfileDisplayModel(
            fullName: stringValue(
                data["fullName"]
            ),
            email: stringValue(
                data["email"]
            ),
            phone: stringValue(
                data["phone"]
            ),
            photoURL:
                stringValue(
                    data["fotoPerfil"]
                )
                .isEmpty
                ? stringValue(
                    data["urlPhoto"]
                )
                : stringValue(
                    data["fotoPerfil"]
                ),
            packageId: stringValue(
                package["idPaquete"]
            ),
            packageName:
                stringValue(
                    package["name"]
                )
                .isEmpty
                ? stringValue(
                    data["membershipName"]
                )
                : stringValue(
                    package["name"]
                ),
            packageExpiration: stringValue(
                package["expiracion"]
            ),
            packageType: intValue(
                package["tipoPaquete"]
            ),
            classesTaken: intValue(
                package["clasesTomadas"]
            ),
            totalClasses: intValue(
                package["clasesTotales"]
            ),
            extraCredits: intValue(
                data["extraCredits"]
            ),
            responsiveSigned: boolValue(
                data["responsiveSigned"]
            ),
            responsiveURL: stringValue(
                data["urlDocumentResponsiva"]
            )
        )
    }

    private func stringValue(
        _ value: Any?
    ) -> String {
        if let value = value as? String {
            return value
        }

        if let value = value as? NSNumber {
            return value.stringValue
        }

        return ""
    }

    private func intValue(
        _ value: Any?
    ) -> Int {
        if let value = value as? Int {
            return value
        }

        if let value = value as? Int64 {
            return Int(value)
        }

        if let value = value as? NSNumber {
            return value.intValue
        }

        if
            let value = value as? String,
            let result = Int(value)
        {
            return result
        }

        return 0
    }

    private func boolValue(
        _ value: Any?
    ) -> Bool {
        if let value = value as? Bool {
            return value
        }

        if let value = value as? NSNumber {
            return value.boolValue
        }

        return false
    }
}
