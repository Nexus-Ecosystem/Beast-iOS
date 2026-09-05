import Foundation
import FirebaseFirestore

protocol ScheduleFirebaseDataSourceProtocol {
    func observeSchedules(
        branch: String,
        day: String,
        month: String,
        onChange: @escaping ([ClassItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration

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

    func observeSchedules(
        branch: String,
        day: String,
        month: String,
        onChange: @escaping ([ClassItem]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        let path = "classes/studios/\(branch)/\(month)/dias/\(day)/SCHEDULES"

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

                let schedules = documents.map {
                    self.mapSchedule(
                        document: $0
                    )
                }

                onChange(schedules)
            }
    }

    func observePendingSchedules(
        branch: String,
        month: String,
        email: String,
        onChange: @escaping ([ClassItemEntity]) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ListenerRegistration {
        /*
         ANDROID:

         users
           /{email}
           /HISTORIAL_CLASSES
           /{yyyy-MM}
           /classes
         */

        let path = "users/\(email)/HISTORIAL_CLASSES/\(month)/classes"

        NetworkLogger.logFirebaseRequest(
            path: path,
            operation: "LISTEN"
        )

        return firestore
            .collection("users")
            .document(email)
            .collection("HISTORIAL_CLASSES")
            .document(month)
            .collection("classes")
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

                let reservations = documents.map {
                    self.mapReservation(
                        document: $0
                    )
                }

                onChange(reservations)
            }
    }

    private func mapSchedule(
        document: QueryDocumentSnapshot
    ) -> ClassItem {
        let data = document.data()

        return ClassItem(
            id: document.documentID,
            name: data["name"] as? String ?? "",
            coach: data["coach"] as? String ?? "",
            photo: data["photo"] as? String ?? "",
            time: data["time"] as? String ?? document.documentID,
            duration: intValue(
                data["duration"]
            ),
            level: intValue(
                data["level"]
            ),
            agenda: intValue(
                data["agenda"]
            ),
            total: intValue(
                data["total"]
            ),
            cancelled:
                data["cancelada"] as? Bool ??
                data["cancelled"] as? Bool ??
                false,
            isScheduled: false
        )
    }

    private func mapReservation(
        document: QueryDocumentSnapshot
    ) -> ClassItemEntity {
        let data = document.data()

        return ClassItemEntity(
            id: nil,
            idFirebase: document.documentID,
            sucursalAgendada:
                data["sucursalAgendada"] as? String ??
                data["idSucursal"] as? String ??
                "",
            diaAgendado:
                data["diaAgendado"] as? String ??
                data["dia"] as? String ??
                "",
            coach:
                data["coach"] as? String ??
                "",
            name:
                data["name"] as? String ??
                "",
            time:
                data["time"] as? String ??
                data["horario"] as? String ??
                "",
            duration: intValue(
                data["duration"]
            ),
            level: intValue(
                data["level"]
            ),
            agenda: intValue(
                data["agenda"]
            ),
            total: intValue(
                data["total"]
            ),
            photo:
                data["photo"] as? String ??
                "",
            cancelled:
                data["cancelada"] as? Bool ??
                data["cancelled"] as? Bool ??
                false,
            isScheduled: true
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

        return 0
    }
}
