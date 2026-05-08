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

    @Test func movementCanContinueAfterEnergyReachesZero() {
        let session = GameSession(profile: .default, seed: 9_137)

        for _ in 0..<20 {
            session.moveDown()
        }

        #expect(session.player.energy == 0)
        #expect(session.currentDepth >= 20)
        #expect(session.tiles.count > 24)
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
