import Foundation

struct PlayerProfile: Codable, Equatable {
    var totalCredits: Int
    var bestDepth: Int
    var totalRuns: Int
    var lifetimeCreditsEarned: Int
    var lifetimeCoinsCollected: Int
    var lifetimeGemsCollected: Int
    var maxHealthLevel: Int
    var maxEnergyLevel: Int
    var startingBombsLevel: Int
    var startingShieldsLevel: Int
    var gemValueLevel: Int
    var feedbackSettings: FeedbackSettings

    static let `default` = PlayerProfile(
        totalCredits: 0,
        bestDepth: 0,
        totalRuns: 0,
        lifetimeCreditsEarned: 0,
        lifetimeCoinsCollected: 0,
        lifetimeGemsCollected: 0,
        maxHealthLevel: 0,
        maxEnergyLevel: 0,
        startingBombsLevel: 0,
        startingShieldsLevel: 0,
        gemValueLevel: 0,
        feedbackSettings: .default
    )

    enum CodingKeys: String, CodingKey {
        case totalCredits
        case bestDepth
        case totalRuns
        case lifetimeCreditsEarned
        case lifetimeCoinsCollected
        case lifetimeGemsCollected
        case maxHealthLevel
        case maxEnergyLevel
        case startingBombsLevel
        case startingShieldsLevel
        case gemValueLevel
        case feedbackSettings
    }

    init(
        totalCredits: Int,
        bestDepth: Int,
        totalRuns: Int,
        lifetimeCreditsEarned: Int,
        lifetimeCoinsCollected: Int,
        lifetimeGemsCollected: Int,
        maxHealthLevel: Int,
        maxEnergyLevel: Int,
        startingBombsLevel: Int,
        startingShieldsLevel: Int,
        gemValueLevel: Int,
        feedbackSettings: FeedbackSettings
    ) {
        self.totalCredits = totalCredits
        self.bestDepth = bestDepth
        self.totalRuns = totalRuns
        self.lifetimeCreditsEarned = lifetimeCreditsEarned
        self.lifetimeCoinsCollected = lifetimeCoinsCollected
        self.lifetimeGemsCollected = lifetimeGemsCollected
        self.maxHealthLevel = maxHealthLevel
        self.maxEnergyLevel = maxEnergyLevel
        self.startingBombsLevel = startingBombsLevel
        self.startingShieldsLevel = startingShieldsLevel
        self.gemValueLevel = gemValueLevel
        self.feedbackSettings = feedbackSettings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.totalCredits = try container.decodeIfPresent(Int.self, forKey: .totalCredits) ?? 0
        self.bestDepth = try container.decodeIfPresent(Int.self, forKey: .bestDepth) ?? 0
        let decodedTotalRuns = try container.decodeIfPresent(Int.self, forKey: .totalRuns)
        self.totalRuns = decodedTotalRuns ?? 0
        self.lifetimeCreditsEarned = try container.decodeIfPresent(Int.self, forKey: .lifetimeCreditsEarned) ?? totalCredits
        self.lifetimeCoinsCollected = try container.decodeIfPresent(Int.self, forKey: .lifetimeCoinsCollected) ?? 0
        self.lifetimeGemsCollected = try container.decodeIfPresent(Int.self, forKey: .lifetimeGemsCollected) ?? 0
        self.maxHealthLevel = try container.decodeIfPresent(Int.self, forKey: .maxHealthLevel) ?? 0
        self.maxEnergyLevel = try container.decodeIfPresent(Int.self, forKey: .maxEnergyLevel) ?? 0
        self.startingBombsLevel = try container.decodeIfPresent(Int.self, forKey: .startingBombsLevel) ?? 0
        self.startingShieldsLevel = try container.decodeIfPresent(Int.self, forKey: .startingShieldsLevel) ?? 0
        self.gemValueLevel = try container.decodeIfPresent(Int.self, forKey: .gemValueLevel) ?? 0
        self.feedbackSettings = try container.decodeIfPresent(FeedbackSettings.self, forKey: .feedbackSettings) ?? .default

        if decodedTotalRuns == nil, hasAnyLegacyProgress {
            self.totalRuns = 1
        }
    }

    private var hasAnyLegacyProgress: Bool {
        totalCredits > 0
            || bestDepth > 0
            || maxHealthLevel > 0
            || maxEnergyLevel > 0
            || startingBombsLevel > 0
            || startingShieldsLevel > 0
            || gemValueLevel > 0
    }

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
        totalRuns += 1
        lifetimeCreditsEarned += result.totalPayout
        lifetimeCoinsCollected += result.coins
        lifetimeGemsCollected += result.gems
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

    mutating func setSoundEnabled(_ isEnabled: Bool) {
        feedbackSettings.isSoundEnabled = isEnabled
    }

    mutating func setHapticsEnabled(_ isEnabled: Bool) {
        feedbackSettings.isHapticsEnabled = isEnabled
    }
}
