import Foundation

struct StudioElementModel: Codable, Identifiable, Equatable {
    let id: String
    let label: String
    let type: String
    let status: String
    let gridX: Int
    let gridY: Int

    init(
        id: String = "",
        label: String = "",
        type: String = "",
        status: String = "active",
        gridX: Int = 0,
        gridY: Int = 0
    ) {
        self.id = id
        self.label = label
        self.type = type
        self.status = status
        self.gridX = gridX
        self.gridY = gridY
    }
}
