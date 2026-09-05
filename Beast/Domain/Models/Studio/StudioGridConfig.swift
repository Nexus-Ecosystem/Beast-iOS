import Foundation

struct StudioGridConfig: Codable, Equatable {
    let cols: Int
    let rows: Int

    init(
        cols: Int = 10,
        rows: Int = 4
    ) {
        self.cols = cols
        self.rows = rows
    }
}
