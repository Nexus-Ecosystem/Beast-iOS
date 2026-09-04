import Foundation
import FirebaseFirestore

struct ClassItemResponse {
    let id: String
    let name: String
    let coach: String
    let photo: String
    let time: String
    let level: Int
    let agenda: Int
    let total: Int
    let cancelled: Bool

    init(document: QueryDocumentSnapshot) {
        let data = document.data()

        id = document.documentID
        name = data["name"] as? String ?? ""
        coach = data["coach"] as? String ?? ""
        photo = data["photo"] as? String ?? ""
        time = data["time"] as? String ?? ""
        level = data["level"] as? Int ?? 1
        agenda = data["agenda"] as? Int ?? 0
        total = data["total"] as? Int ?? 0

        if let value = data["cancelada"] as? Bool {
            cancelled = value
        } else if let value = data["cancelled"] as? Bool {
            cancelled = value
        } else {
            cancelled = false
        }
    }
}
