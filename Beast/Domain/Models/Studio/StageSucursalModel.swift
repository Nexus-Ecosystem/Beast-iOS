import Foundation

struct StageSucursalModel: Codable, Equatable {
    let myBikes: [StudioElementModel]
    let gridConfig: StudioGridConfig?

    init(
        myBikes: [StudioElementModel] = [],
        gridConfig: StudioGridConfig? = nil
    ) {
        self.myBikes = myBikes
        self.gridConfig = gridConfig
    }
}
