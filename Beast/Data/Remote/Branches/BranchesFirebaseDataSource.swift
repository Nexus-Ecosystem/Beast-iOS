import Foundation
import FirebaseFirestore

protocol BranchesFirebaseDataSourceProtocol {
    func getAllBranches() async throws -> [BranchModel]
}

final class BranchesFirebaseDataSource:
    BranchesFirebaseDataSourceProtocol
{
    private let firestore:
        Firestore

    init(
        firestore:
            Firestore =
                Firestore.firestore()
    ) {
        self.firestore =
            firestore
    }

    func getAllBranches()
        async throws -> [BranchModel]
    {
        let path =
            "branches"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "GET"
        )

        do {
            let snapshot =
                try await firestore
                    .collection(
                        "branches"
                    )
                    .getDocuments()

            return snapshot
                .documents
                .map {
                    mapBranch(
                        id:
                            $0.documentID,
                        data:
                            $0.data()
                    )
                }
        } catch {
            NetworkLogger.logFirebaseError(
                path: path,
                error: error
            )

            throw error
        }
    }

    private func mapBranch(
        id: String,
        data: [String: Any]
    ) -> BranchModel {
        BranchModel(
            idBranch:
                string(
                    data["idBranch"]
                ).isEmpty
                ? id
                : string(
                    data["idBranch"]
                ),
            name:
                string(
                    data["name"]
                ),
            address:
                string(
                    data["address"]
                ),
            phone:
                string(
                    data["phone"]
                ),
            email:
                string(
                    data["email"]
                ),
            rating:
                double(
                    data["rating"]
                ),
            gallery:
                stringArray(
                    data["galery"]
                )
        )
    }

    private func string(
        _ value: Any?
    ) -> String {
        if let value =
            value as? String {
            return value
        }

        if let value =
            value as? NSNumber {
            return value.stringValue
        }

        return ""
    }

    private func double(
        _ value: Any?
    ) -> Double {
        if let value =
            value as? Double {
            return value
        }

        if let value =
            value as? NSNumber {
            return value.doubleValue
        }

        if let value =
            value as? String {
            return Double(
                value
            ) ?? 0
        }

        return 0
    }

    private func stringArray(
        _ value: Any?
    ) -> [String] {
        value as? [String] ?? []
    }
}
