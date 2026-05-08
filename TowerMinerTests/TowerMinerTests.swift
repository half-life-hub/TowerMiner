//
//  TowerMinerTests.swift
//  TowerMinerTests
//
//  Created by Steven Marshall on 7/5/2026.
//

import Testing
@testable import TowerMiner

struct TowerMinerTests {
    @Test func movingLeftAdvancesIntoOpenSpace() {
        let session = GameSession(profile: .default, seed: 9_137)

        session.moveLeft()

        #expect(session.player.position == GridPosition(row: 3, column: 3))
        #expect(session.currentDepth == 2)
    }

    @Test func diggingAdjacentBlockClearsItAndConsumesEnergy() {
        let session = GameSession(profile: .default, seed: 9_137)

        session.moveLeft()
        let target = GridPosition(row: 4, column: 3)

        #expect(session.canDig(at: target))

        session.dig(at: target)

        #expect(session.tile(at: target)?.type == .empty)
        #expect(session.player.energy == 9)
    }

    @Test func movementContinuesWhileEnergyRecovers() {
        let session = GameSession(profile: .default, seed: 9_137)

        for _ in 0..<20 {
            session.moveDown()
        }

        #expect(session.currentDepth >= 20)
        #expect(session.tiles.count > 24)
        #expect(!session.isRunOver)
    }

    @Test func exhaustedDiggingCostsHealth() {
        let session = GameSession(profile: .default, seed: 9_137)

        session.moveLeft()
        session.player.energy = 0
        session.dig(at: GridPosition(row: 4, column: 3))

        #expect(session.player.health == 4)
        #expect(!session.isRunOver)
    }

    @Test func spikeDamagesPlayerAndClearsAfterEntry() {
        let session = GameSession(profile: .default, seed: 9_137)
        let spikePosition = session.player.position.offsetBy(columns: 1)

        session.tiles[spikePosition.row][spikePosition.column] = MineTile(type: .spike)
        session.moveRight()

        #expect(session.player.health == 4)
        #expect(session.tile(at: spikePosition)?.type == .empty)
        #expect(!session.isRunOver)
    }

    @Test func lavaCanEndRun() {
        let session = GameSession(profile: .default, seed: 9_137)
        let lavaPosition = session.player.position.offsetBy(columns: 1)

        session.player.health = 1
        session.tiles[lavaPosition.row][lavaPosition.column] = MineTile(type: .lava)
        session.moveRight()

        #expect(session.player.health == 0)
        #expect(session.isRunOver)
    }

    @Test func shieldAbsorbsOneHazardHit() {
        let session = GameSession(profile: .default, seed: 9_137)
        let lavaPosition = session.player.position.offsetBy(columns: 1)

        session.useShield()
        session.tiles[lavaPosition.row][lavaPosition.column] = MineTile(type: .lava)
        session.moveRight()

        #expect(session.player.health == 5)
        #expect(session.player.shields == 0)
        #expect(session.player.activeShieldHits == 0)
        #expect(!session.isRunOver)
    }

    @Test func generatorKeepsOpeningRowsSafe() {
        let generator = MineGenerator(columns: 9, seed: 9_137)
        let rows = generator.makeInitialRows(count: 4, startColumn: 4)

        #expect(rows[0].allSatisfy(\.isEmpty))
        #expect(rows[1][3].isEmpty)
        #expect(rows[1][4].isEmpty)
        #expect(rows[1][5].isEmpty)
    }

    @Test func deeperRowsCanIncludeHardStoneAndHazards() {
        let generator = MineGenerator(columns: 9, seed: 9_137)
        let rows = generator.makeRows(from: 55, count: 12, startColumn: 4)
        let tileTypes = rows.flatMap { row in row.map(\.type) }

        #expect(tileTypes.contains(.hardStone))
        #expect(tileTypes.contains(.lava) || tileTypes.contains(.spike))
    }
}
