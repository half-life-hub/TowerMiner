import Foundation
import Observation

@Observable
final class GameSession {
    let columns: Int
    let visibleRowCount: Int
    let rowBufferCount: Int
    let generator: MineGenerator

    var tiles: [[MineTile]]
    var player: PlayerState
    var digPower: Int

    init(
        profile: PlayerProfile,
        columns: Int = 9,
        initialRowCount: Int = 24,
        visibleRowCount: Int = 12,
        rowBufferCount: Int = 12,
        seed: UInt64 = UInt64.random(in: UInt64.min...UInt64.max)
    ) {
        self.columns = columns
        self.visibleRowCount = visibleRowCount
        self.rowBufferCount = rowBufferCount
        self.generator = MineGenerator(columns: columns, seed: seed)
        self.digPower = 1

        let startColumn = columns / 2
        self.tiles = generator.makeInitialRows(count: initialRowCount, startColumn: startColumn)
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
        let minRow = max(0, min(player.position.row - halfWindow, tiles.count - visibleRowCount))
        let maxRow = min(tiles.count - 1, minRow + visibleRowCount - 1)
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

        return tile.isDiggable
            && player.position.manhattanDistance(to: position) == 1
    }

    func moveLeft() {
        attemptMoveOrDig(to: player.position.offsetBy(columns: -1))
    }

    func moveRight() {
        attemptMoveOrDig(to: player.position.offsetBy(columns: 1))
    }

    func moveDown() {
        attemptMoveOrDig(to: player.position.offsetBy(rows: 1))
    }

    func dig(at position: GridPosition) {
        guard canDig(at: position) else {
            return
        }

        tiles[position.row][position.column].applyDig(power: digPower)
        player.energy = max(0, player.energy - 1)
        applyGravityIfNeeded()
    }

    private func attemptMoveOrDig(to destination: GridPosition) {
        guard isWithinBounds(destination) else {
            return
        }

        if tiles[destination.row][destination.column].isDiggable {
            dig(at: destination)
            return
        }

        guard tiles[destination.row][destination.column].isEmpty else {
            return
        }
        
        player.position = destination
        ensureRowsAvailable()
        applyGravityIfNeeded()
    }

    private func applyGravityIfNeeded() {
        while true {
            let below = player.position.offsetBy(rows: 1)
            guard isWithinBounds(below), tiles[below.row][below.column].isEmpty else {
                break
            }

            player.position = below
            ensureRowsAvailable()
        }
    }

    private func isWithinBounds(_ position: GridPosition) -> Bool {
        position.row >= 0 && position.row < tiles.count && position.column >= 0 && position.column < columns
    }

    private func ensureRowsAvailable() {
        let remainingRows = tiles.count - player.position.row
        guard remainingRows <= visibleRowCount else {
            return
        }

        let newRows = generator.makeRows(
            from: tiles.count,
            count: rowBufferCount,
            startColumn: columns / 2
        )
        tiles.append(contentsOf: newRows)
    }
}
