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
        let session = GameSession(profile: .default)

        session.moveLeft()

        #expect(session.player.position == GridPosition(row: 2, column: 3))
    }

    @Test func diggingAdjacentBlockClearsItAndConsumesEnergy() {
        let session = GameSession(profile: .default)

        session.moveLeft()
        let target = GridPosition(row: 3, column: 3)

        #expect(session.canDig(at: target))

        session.dig(at: target)

        #expect(session.tile(at: target)?.type == .empty)
        #expect(session.player.energy == 9)
    }
}
