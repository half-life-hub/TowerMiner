import Foundation

struct PlayerProfile: Codable, Equatable {
    var totalCredits: Int
    var bestDepth: Int
    var maxHealthLevel: Int
    var maxEnergyLevel: Int
    var startingBombsLevel: Int
    var startingShieldsLevel: Int
    var gemValueLevel: Int

    static let `default` = PlayerProfile(
        totalCredits: 0,
        bestDepth: 0,
        maxHealthLevel: 0,
        maxEnergyLevel: 0,
        startingBombsLevel: 0,
        startingShieldsLevel: 0,
        gemValueLevel: 0
    )

    func level(for upgrade: UpgradeID) -> Int {
        switch upgrade {
        case .maxHealth:
            return maxHealthLevel
        case .maxEnergy:
            return maxEnergyLevel
        case .startingBombs:
            return startingBombsLevel
        case .startingShields:
            return startingShieldsLevel
        case .gemValue:
            return gemValueLevel
        }
    }

    mutating func apply(_ result: RunResult) {
        totalCredits += result.totalPayout
        bestDepth = max(bestDepth, result.depth)
    }

    mutating func purchase(_ upgrade: UpgradeID) -> Bool {
        let currentLevel = level(for: upgrade)
        guard currentLevel < upgrade.maxLevel else {
            return false
        }

        let cost = upgrade.cost(for: currentLevel)
        guard totalCredits >= cost else {
            return false
        }

        totalCredits -= cost
        switch upgrade {
        case .maxHealth:
            maxHealthLevel += 1
        case .maxEnergy:
            maxEnergyLevel += 1
        case .startingBombs:
            startingBombsLevel += 1
        case .startingShields:
            startingShieldsLevel += 1
        case .gemValue:
            gemValueLevel += 1
        }

        return true
    }
}
