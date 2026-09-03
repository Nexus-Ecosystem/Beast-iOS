import Foundation
import FirebaseFirestore

protocol ScheduleFirebaseDataSourceProtocol {
    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping ([ClassItemEntity]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration
}

final class ScheduleFirebaseDataSource: ScheduleFirebaseDataSourceProtocol {
    private let firestore: Firestore

    init(
        firestore: Firestore = Firestore.firestore()
    ) {
        self.firestore = firestore
    }

    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping ([ClassItemEntity]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        let path =
            "users/\(email)/HISTORIAL_CLASSES/\(branch)/\(month)"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "LISTEN"
        )

        return firestore
            .collection("users")
            .document(email)
            .collection("HISTORIAL_CLASSES")
            .document(branch)
            .collection(month)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    NetworkLogger.logFirebaseError(
                        path: path,
                        error: error
                    )

                    onError(error)
                    return
                }

                let rawDocuments = snapshot?
                    .documents
                    .map { document -> [String: Any] in
                        var data = document.data()
                        data["_documentId"] = document.documentID
                        return data
                    } ?? []

                NetworkLogger.logFirebaseResponse(
                    path: path,
                    documents: rawDocuments
                )

                let reservations = snapshot?
                    .documents
                    .map {
                        self.mapReservation(
                            document: $0
                        )
                    } ?? []

                onChange(reservations)
            }
    }

    private func mapReservation(
        document: QueryDocumentSnapshot
    ) -> ClassItemEntity {
        let data = document.data()

        return ClassItemEntity(
            id: nil,
            idFirebase: data["idFirebase"] as? String ?? document.documentID,
            sucursalAgendada: data["sucursalAgendada"] as? String ?? "",
            diaAgendado: data["diaAgendado"] as? String ?? "",
            coach: data["coach"] as? String ?? "",
            name: data["name"] as? String ?? "",
            time: data["time"] as? String ?? "",
            duration: data["duration"] as? Int ?? 0,
            level: data["level"] as? Int ?? 0,
            agenda: data["agenda"] as? Int ?? 0,
            total: data["total"] as? Int ?? 0,
            photo: data["photo"] as? String ?? "",
            isScheduled: data["isScheduled"] as? Bool ?? false
        )
    }
}
