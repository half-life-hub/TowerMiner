import Foundation
import Observation

@Observable
final class GameSession {
    let columns: Int
    let totalRows: Int
    let visibleRowCount: Int

    var tiles: [[MineTile]]
    var player: PlayerState
    var digPower: Int

    init(
        profile: PlayerProfile,
        columns: Int = 9,
        totalRows: Int = 24,
        visibleRowCount: Int = 12
    ) {
        self.columns = columns
        self.totalRows = totalRows
        self.visibleRowCount = visibleRowCount
        self.digPower = 1

        let startColumn = columns / 2
        self.tiles = GameSession.makeStartingMine(columns: columns, totalRows: totalRows, startColumn: startColumn)
        self.player = PlayerState(
            position: GridPosition(row: 1, column: startColumn),
            health: 5 + profile.maxHealthLevel,
            energy: 10 + (profile.maxEnergyLevel * 2),
            bombs: 1 + profile.startingBombsLevel,
            shields: 1 + profile.startingShieldsLevel
        )
    }

    var currentDepth: Int {
        max(0, player.position.row - 1)
    }

    var visibleRowRange: ClosedRange<Int> {
        let halfWindow = visibleRowCount / 2
        let minRow = max(0, min(player.position.row - halfWindow, totalRows - visibleRowCount))
        let maxRow = min(totalRows - 1, minRow + visibleRowCount - 1)
        return minRow...maxRow
    }

    func tile(at position: GridPosition) -> MineTile? {
        guard isWithinBounds(position) else {
            return nil
        }

        return tiles[position.row][position.column]
    }

    func canDig(at position: GridPosition) -> Bool {
        guard let tile = tile(at: position) else {
            return false
        }

        return player.energy > 0
            && tile.isDiggable
            && player.position.manhattanDistance(to: position) == 1
    }

    func moveLeft() {
        attemptMove(to: player.position.offsetBy(columns: -1))
    }

    func moveRight() {
        attemptMove(to: player.position.offsetBy(columns: 1))
    }

    func moveDown() {
        attemptMove(to: player.position.offsetBy(rows: 1))
    }

    func dig(at position: GridPosition) {
        guard canDig(at: position) else {
            return
        }

        tiles[position.row][position.column].applyDig(power: digPower)
        player.energy -= 1
        applyGravityIfNeeded()
    }

    private func attemptMove(to destination: GridPosition) {
        guard isWithinBounds(destination) else {
            return
        }

        guard tiles[destination.row][destination.column].isEmpty else {
            return
        }

        player.position = destination
        applyGravityIfNeeded()
    }

    private func applyGravityIfNeeded() {
        while true {
            let below = player.position.offsetBy(rows: 1)
            guard isWithinBounds(below), tiles[below.row][below.column].isEmpty else {
                break
            }

            player.position = below
        }
    }

    private func isWithinBounds(_ position: GridPosition) -> Bool {
        position.row >= 0 && position.row < totalRows && position.column >= 0 && position.column < columns
    }

    private static func makeStartingMine(columns: Int, totalRows: Int, startColumn: Int) -> [[MineTile]] {
        var grid = Array(
            repeating: Array(repeating: MineTile(type: .dirt), count: columns),
            count: totalRows
        )

        for row in 0..<totalRows {
            for column in 0..<columns {
                if row == 0 {
                    grid[row][column] = MineTile(type: .empty)
                    continue
                }

                let distanceFromCenter = abs(column - startColumn)
                if column == startColumn && row <= 3 {
                    grid[row][column] = MineTile(type: .empty)
                } else if distanceFromCenter == 1 && row <= 2 {
                    grid[row][column] = MineTile(type: .empty)
                } else if row > 4 && ((row + column) % 5 == 0) {
                    grid[row][column] = MineTile(type: .stone)
                } else {
                    grid[row][column] = MineTile(type: .dirt)
                }
            }
        }

        return grid
    }
}
