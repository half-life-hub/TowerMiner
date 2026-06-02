import Foundation

struct PlayerProfile: Codable, Equatable {
    var totalCredits: Int
    var bestDepth: Int
    var maxHealthLevel: Int
    var maxEnergyLevel: Int
    var startingBombsLevel: Int
    var startingShieldsLevel: Int
    var gemValueLevel: Int
    var feedbackSettings: FeedbackSettings

    static let `default` = PlayerProfile(
        totalCredits: 0,
        bestDepth: 0,
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
        maxHealthLevel: Int,
        maxEnergyLevel: Int,
        startingBombsLevel: Int,
        startingShieldsLevel: Int,
        gemValueLevel: Int,
        feedbackSettings: FeedbackSettings
    ) {
        self.totalCredits = totalCredits
        self.bestDepth = bestDepth
        self.maxHealthLevel = maxHealthLevel
        self.maxEnergyLevel = maxEnergyLevel
        self.startingBombsLevel = startingBombsLevel
        self.startingShieldsLevel = startingShieldsLevel
        self.gemValueLevel = gemValueLevel
        self.feedbackSettings = feedbackSettings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.totalCredits = try container.decode(Int.self, forKey: .totalCredits)
        self.bestDepth = try container.decode(Int.self, forKey: .bestDepth)
        self.maxHealthLevel = try container.decode(Int.self, forKey: .maxHealthLevel)
        self.maxEnergyLevel = try container.decode(Int.self, forKey: .maxEnergyLevel)
        self.startingBombsLevel = try container.decode(Int.self, forKey: .startingBombsLevel)
        self.startingShieldsLevel = try container.decode(Int.self, forKey: .startingShieldsLevel)
        self.gemValueLevel = try container.decode(Int.self, forKey: .gemValueLevel)
        self.feedbackSettings = try container.decodeIfPresent(FeedbackSettings.self, forKey: .feedbackSettings) ?? .default
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
