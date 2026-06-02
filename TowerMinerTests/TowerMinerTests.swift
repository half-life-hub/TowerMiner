//
//  TowerMinerTests.swift
//  TowerMinerTests
//
//  Created by Steven Marshall on 7/5/2026.
//

import Foundation
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
        let target = session.player.position.offsetBy(columns: 1)
        session.tiles[session.player.position.row + 1][session.player.position.column] = MineTile(type: .dirt)
        session.tiles[target.row][target.column] = MineTile(type: .dirt)

        #expect(session.canDig(at: target))

        session.dig(at: target)

        #expect(session.tile(at: target)?.type == .empty)
        #expect(session.player.energy == 9)
    }

    @Test func directionalDigMovesIntoOneDurabilityTileWhenItClears() {
        let session = GameSession(profile: .default, seed: 9_137)
        let target = session.player.position.offsetBy(columns: 1)

        session.tiles[target.row][target.column] = MineTile(type: .dirt)
        session.tiles[session.player.position.row + 1][session.player.position.column] = MineTile(type: .dirt)

        session.moveRight()

        #expect(session.tile(at: target)?.type == .empty)
        #expect(session.player.position.column == target.column)
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

    @Test func miningRewardTilesAddsRunInventory() {
        let session = GameSession(profile: .default, seed: 9_137)
        let goldPosition = session.player.position.offsetBy(columns: 1)
        let gemPosition = session.player.position.offsetBy(columns: -1)

        session.tiles[session.player.position.row + 1][session.player.position.column] = MineTile(type: .dirt)
        session.tiles[goldPosition.row][goldPosition.column] = MineTile(type: .gold)
        session.tiles[gemPosition.row][gemPosition.column] = MineTile(type: .gem)

        session.dig(at: goldPosition)
        session.dig(at: gemPosition)

        #expect(session.player.coins == 4)
        #expect(session.player.gems == 1)
    }

    @Test func bombClearsNearbyTilesAndConsumesInventory() {
        let session = GameSession(profile: .default, seed: 9_137)
        let target = session.player.position.offsetBy(columns: 1)
        let goldPosition = target.offsetBy(rows: 1)
        let gemPosition = target.offsetBy(columns: 1)

        session.tiles[target.row][target.column] = MineTile(type: .stone)
        session.tiles[goldPosition.row][goldPosition.column] = MineTile(type: .gold)
        session.tiles[gemPosition.row][gemPosition.column] = MineTile(type: .gem)

        let placed = session.useBomb(at: target)
        let targetWasIncludedInBlast = session.lastBombedPositions.contains { position in
            position.row == target.row && position.column == target.column
        }

        #expect(placed)
        #expect(session.player.bombs == 0)
        #expect(session.tile(at: target)?.type == .empty)
        #expect(session.tile(at: goldPosition)?.type == .empty)
        #expect(session.tile(at: gemPosition)?.type == .empty)
        #expect(session.player.coins == 4)
        #expect(session.player.gems == 1)
        #expect(targetWasIncludedInBlast)
    }

    @Test func runResultCalculatesTotalPayout() {
        let result = RunResult(depth: 20, coins: 12, gems: 3, gemValue: 5)

        #expect(result.coinPayout == 12)
        #expect(result.gemPayout == 15)
        #expect(result.depthBonus == 10)
        #expect(result.totalPayout == 37)
    }

    @Test func profileAppliesResultAndPurchasesUpgrade() {
        var profile = PlayerProfile.default
        let result = RunResult(depth: 30, coins: 10, gems: 2, gemValue: 5)

        profile.apply(result)

        #expect(profile.totalCredits == 35)
        #expect(profile.bestDepth == 30)

        let purchased = profile.purchase(.maxHealth)

        #expect(purchased)
        #expect(profile.maxHealthLevel == 1)
        #expect(profile.totalCredits == 0)
    }

    @Test func profileDecodesLegacySaveWithDefaultFeedbackSettings() throws {
        let legacyJSON = """
        {
            "totalCredits": 12,
            "bestDepth": 18,
            "maxHealthLevel": 1,
            "maxEnergyLevel": 2,
            "startingBombsLevel": 0,
            "startingShieldsLevel": 1,
            "gemValueLevel": 0
        }
        """
        let data = try #require(legacyJSON.data(using: .utf8))

        let profile = try JSONDecoder().decode(PlayerProfile.self, from: data)

        #expect(profile.totalCredits == 12)
        #expect(profile.feedbackSettings == .default)
    }

    @Test func purchasedUpgradesAffectNextSession() {
        var profile = PlayerProfile.default
        profile.totalCredits = 500

        _ = profile.purchase(.maxHealth)
        _ = profile.purchase(.maxEnergy)
        _ = profile.purchase(.startingShields)
        _ = profile.purchase(.gemValue)

        let session = GameSession(profile: profile, seed: 9_137)

        #expect(session.player.maxHealth == 6)
        #expect(session.player.maxEnergy == 12)
        #expect(session.player.shields == 2)
        #expect(session.gemValue == 7)
    }

    @Test func generatorKeepsOpeningRowsSafe() {
        let generator = MineGenerator(columns: 9, seed: 9_137)
        let rows = generator.makeInitialRows(count: 4, startColumn: 4)
        let openingRowIsSafe = !rows[0].map(\.isEmpty).contains(false)

        #expect(openingRowIsSafe)
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
