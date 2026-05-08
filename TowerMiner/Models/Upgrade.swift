import Foundation

enum UpgradeID: String, CaseIterable, Codable, Identifiable {
    case maxHealth
    case maxEnergy
    case startingBombs
    case startingShields
    case gemValue

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .maxHealth:
            return "Max Health"
        case .maxEnergy:
            return "Max Energy"
        case .startingBombs:
            return "Starting Bombs"
        case .startingShields:
            return "Starting Shields"
        case .gemValue:
            return "Gem Value"
        }
    }

    var description: String {
        switch self {
        case .maxHealth:
            return "+1 max health per level"
        case .maxEnergy:
            return "+2 max energy per level"
        case .startingBombs:
            return "+1 starting bomb per level"
        case .startingShields:
            return "+1 starting shield per level"
        case .gemValue:
            return "+2 credits per gem per level"
        }
    }

    var maxLevel: Int {
        switch self {
        case .maxHealth, .maxEnergy:
            return 5
        case .startingBombs, .startingShields, .gemValue:
            return 3
        }
    }

    var baseCost: Int {
        switch self {
        case .maxHealth:
            return 20
        case .maxEnergy:
            return 18
        case .startingBombs:
            return 25
        case .startingShields:
            return 22
        case .gemValue:
            return 30
        }
    }

    func cost(for currentLevel: Int) -> Int {
        baseCost * (currentLevel + 1)
    }
}
