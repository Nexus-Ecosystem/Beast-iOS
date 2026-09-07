import Foundation

enum HistoryFilter: String, CaseIterable, Identifiable {
    case week = "Semana"
    case month = "Mes"
    case year = "Año"

    var id: Self {
        self
    }
}
