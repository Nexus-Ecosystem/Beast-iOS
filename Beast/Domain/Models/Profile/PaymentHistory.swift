import Foundation

struct PaymentHistory: Codable, Identifiable {
    let id: String
    let amount: Double
    let date: String
    let concept: String
    let status: String

    init(
        id: String = "",
        amount: Double = 0,
        date: String = "",
        concept: String = "",
        status: String = ""
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.concept = concept
        self.status = status
    }
}
