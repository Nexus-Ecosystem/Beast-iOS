import Foundation

struct ClassHistory: Codable, Identifiable {
    let id: String
    let className: String
    let date: String
    let hour: String
    let coachName: String

    init(
        id: String = "",
        className: String = "",
        date: String = "",
        hour: String = "",
        coachName: String = ""
    ) {
        self.id = id
        self.className = className
        self.date = date
        self.hour = hour
        self.coachName = coachName
    }
}
