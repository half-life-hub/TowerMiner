import Foundation

struct GridPosition: Hashable {
    var row: Int
    var column: Int

    func offsetBy(rows: Int = 0, columns: Int = 0) -> GridPosition {
        GridPosition(row: row + rows, column: column + columns)
    }

    func manhattanDistance(to other: GridPosition) -> Int {
        abs(row - other.row) + abs(column - other.column)
    }
}
