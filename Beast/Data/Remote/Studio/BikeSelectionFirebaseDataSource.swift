import Foundation
import FirebaseFirestore

protocol BikeSelectionFirebaseDataSourceProtocol {
    func observeStage(
        branch: String,
        onChange: @escaping (StageSucursalModel?) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration

    func observeBikeSelection(
        branch: String,
        day: String,
        month: String,
        time: String,
        onChange: @escaping ([AgendaItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration
}

final class BikeSelectionFirebaseDataSource: BikeSelectionFirebaseDataSourceProtocol {
    private let firestore: Firestore

    init(
        firestore: Firestore = Firestore.firestore()
    ) {
        self.firestore = firestore
    }

    func observeStage(
        branch: String,
        onChange: @escaping (StageSucursalModel?) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        let path = "stagesSucursals/\(branch)"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "LISTEN"
        )

        return firestore
            .collection("stagesSucursals")
            .document(branch)
            .addSnapshotListener { snapshot, error in
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
                    onChange(nil)
                    return
                }

                let data = snapshot.data() ?? [:]

                NetworkLogger.logFirebaseResponse(
                    path: path,
                    document: data
                )

                onChange(
                    self.mapStage(
                        data: data
                    )
                )
            }
    }

    func observeBikeSelection(
        branch: String,
        day: String,
        month: String,
        time: String,
        onChange: @escaping ([AgendaItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        let path =
            "classes/studios/\(branch)/\(month)/dias/\(day)/SCHEDULES/\(time)/AGENDAS"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "LISTEN"
        )

        return firestore
            .collection("classes")
            .document("studios")
            .collection(branch)
            .document(month)
            .collection("dias")
            .document(day)
            .collection("SCHEDULES")
            .document(time)
            .collection("AGENDAS")
            .addSnapshotListener { snapshot, error in
                if let error {
                    NetworkLogger.logFirebaseError(
                        path: path,
                        error: error
                    )

                    onError(error)
                    return
                }

                let documents = snapshot?.documents ?? []

                let rawDocuments = documents.map { document in
                    var data = document.data()
                    data["_documentId"] = document.documentID
                    return data
                }

                NetworkLogger.logFirebaseResponse(
                    path: path,
                    documents: rawDocuments
                )

                let selections = documents.map { document in
                    self.mapAgendaItem(
                        document: document
                    )
                }

                onChange(selections)
            }
    }

    private func mapStage(
        data: [String: Any]
    ) -> StageSucursalModel {
        let rawElements =
            data["myBikes"] as? [[String: Any]] ??
            []

        let elements = rawElements.map {
            mapStudioElement(
                data: $0
            )
        }

        let rawGrid =
            data["gridConfig"] as? [String: Any]

        let gridConfig = rawGrid.map {
            StudioGridConfig(
                cols: intValue(
                    $0["cols"]
                ),
                rows: intValue(
                    $0["rows"]
                )
            )
        }

        return StageSucursalModel(
            myBikes: elements,
            gridConfig: gridConfig
        )
    }

    private func mapStudioElement(
        data: [String: Any]
    ) -> StudioElementModel {
        StudioElementModel(
            id: stringValue(
                data["id"]
            ),
            label:
                data["label"] as? String ??
                "",
            type:
                data["type"] as? String ??
                "",
            status:
                data["status"] as? String ??
                "active",
            gridX: intValue(
                data["gridX"]
            ),
            gridY: intValue(
                data["gridY"]
            )
        )
    }

    private func stringValue(
        _ value: Any?
    ) -> String {
        if let value = value as? String {
            return value
        }

        if let value = value as? Int {
            return String(value)
        }

        if let value = value as? Int64 {
            return String(value)
        }

        if let value = value as? NSNumber {
            return value.stringValue
        }

        return ""
    }

    private func mapAgendaItem(
        document: QueryDocumentSnapshot
    ) -> AgendaItem {
        let data = document.data()

        return AgendaItem(
            id: document.documentID,
            correo:
                data["correo"] as? String ??
                "",
            asignacionMobiliario:
                data["asignacionMobiliario"] as? String ??
                ""
        )
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

        if let value = value as? String,
           let result = Int(value) {
            return result
        }

        return 0
    }
}
