import Foundation
import Observation

@Observable
final class GameSession {
    let columns: Int
    let visibleRowCount: Int
    let rowBufferCount: Int
    let generator: MineGenerator
    let gemValue: Int

    var tiles: [[MineTile]]
    var player: PlayerState
    var digPower: Int
    var isRunOver: Bool

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
        self.gemValue = 5 + (profile.gemValueLevel * 2)
        self.digPower = 1
        self.isRunOver = false

        let startColumn = columns / 2
        let maxHealth = 5 + profile.maxHealthLevel
        let maxEnergy = 10 + (profile.maxEnergyLevel * 2)
        self.tiles = generator.makeInitialRows(count: initialRowCount, startColumn: startColumn)
        self.player = PlayerState(
            position: GridPosition(row: 1, column: startColumn),
            maxHealth: maxHealth,
            health: maxHealth,
            maxEnergy: maxEnergy,
            energy: maxEnergy,
            coins: 0,
            gems: 0,
            bombs: 1 + profile.startingBombsLevel,
            shields: 1 + profile.startingShieldsLevel,
            activeShieldHits: 0
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
        guard !isRunOver else {
            return false
        }

        guard let tile = tile(at: position) else {
            return false
        }

        return tile.isDiggable
            && player.position.manhattanDistance(to: position) == 1
    }

    func moveLeft() {
        guard !isRunOver else {
            return
        }

        attemptMoveOrDig(to: player.position.offsetBy(columns: -1))
    }

    func moveRight() {
        guard !isRunOver else {
            return
        }

        attemptMoveOrDig(to: player.position.offsetBy(columns: 1))
    }

    func moveDown() {
        guard !isRunOver else {
            return
        }

        attemptMoveOrDig(to: player.position.offsetBy(rows: 1))
    }

    func dig(at position: GridPosition) {
        guard !isRunOver else {
            return
        }

        guard canDig(at: position) else {
            return
        }

        let coinReward = tiles[position.row][position.column].coinReward
        let gemReward = tiles[position.row][position.column].gemReward
        tiles[position.row][position.column].applyDig(power: digPower)
        if tiles[position.row][position.column].isEmpty {
            player.coins += coinReward
            player.gems += gemReward
        }

        spendEnergyOrHealth()
        guard !isRunOver else {
            return
        }

        applyGravityIfNeeded()
    }

    func useShield() {
        guard !isRunOver, player.shields > 0, player.activeShieldHits == 0 else {
            return
        }

        player.shields -= 1
        player.activeShieldHits = 1
    }

    func makeRunResult() -> RunResult {
        RunResult(
            depth: currentDepth,
            coins: player.coins,
            gems: player.gems,
            gemValue: gemValue
        )
    }

    private func attemptMoveOrDig(to destination: GridPosition) {
        guard isWithinBounds(destination) else {
            return
        }

        if tiles[destination.row][destination.column].isDiggable {
            dig(at: destination)
            return
        }

        guard tiles[destination.row][destination.column].isPassable else {
            return
        }
        
        player.position = destination
        resolveTileInteraction(at: destination)
        guard !isRunOver else {
            return
        }

        recoverEnergy()
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
            resolveTileInteraction(at: below)
            guard !isRunOver else {
                break
            }

            recoverEnergy()
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

    private func spendEnergyOrHealth() {
        if player.energy > 0 {
            player.energy -= 1
        } else {
            applyDamage(1)
        }
    }

    private func recoverEnergy() {
        player.energy = min(player.maxEnergy, player.energy + 1)
    }

    private func resolveTileInteraction(at position: GridPosition) {
        let tile = tiles[position.row][position.column]
        guard tile.isHazard else {
            return
        }

        applyDamage(tile.damage)

        if tile.type == .spike {
            tiles[position.row][position.column] = MineTile(type: .empty)
        }
    }

    private func applyDamage(_ amount: Int) {
        guard amount > 0 else {
            return
        }

        if player.activeShieldHits > 0 {
            player.activeShieldHits -= 1
            return
        }

        player.health = max(0, player.health - amount)
        if player.health == 0 {
            isRunOver = true
        }
    }
}
