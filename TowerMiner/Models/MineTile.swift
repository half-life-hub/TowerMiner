import Foundation

enum TileType: String, CaseIterable {
    case empty
    case dirt
    case stone
    case hardStone
    case gold
    case gem
    case chest
    case lava
    case spike

    var durability: Int {
        switch self {
        case .empty:
            return 0
        case .dirt:
            return 1
        case .stone:
            return 2
        case .hardStone:
            return 3
        case .gold, .gem:
            return 1
        case .chest:
            return 2
        case .lava, .spike:
            return 0
        }
    }

    var isDiggable: Bool {
        switch self {
        case .dirt, .stone, .hardStone, .gold, .gem, .chest:
            return true
        case .empty, .lava, .spike:
            return false
        }
    }

    var isHazard: Bool {
        switch self {
        case .lava, .spike:
            return true
        case .empty, .dirt, .stone, .hardStone, .gold, .gem, .chest:
            return false
        }
    }

    var damage: Int {
        switch self {
        case .lava:
            return 2
        case .spike:
            return 1
        case .empty, .dirt, .stone, .hardStone, .gold, .gem, .chest:
            return 0
        }
    }

    var coinReward: Int {
        switch self {
        case .gold:
            return 4
        case .chest:
            return 8
        case .empty, .dirt, .stone, .hardStone, .gem, .lava, .spike:
            return 0
        }
    }

    var gemReward: Int {
        switch self {
        case .gem:
            return 1
        case .chest:
            return 1
        case .empty, .dirt, .stone, .hardStone, .gold, .lava, .spike:
            return 0
        }
    }
}

struct MineTile: Equatable {
    var type: TileType
    var durability: Int

    init(type: TileType) {
        self.type = type
        self.durability = type.durability
    }

    var isEmpty: Bool {
        type == .empty
    }

    var isDiggable: Bool {
        type.isDiggable
    }

    var isHazard: Bool {
        type.isHazard
    }

    var isPassable: Bool {
        isEmpty || isHazard
    }

    var damage: Int {
        type.damage
    }

    var coinReward: Int {
        type.coinReward
    }

    var gemReward: Int {
        type.gemReward
    }

    mutating func applyDig(power: Int = 1) {
        guard isDiggable else {
            return
        }

        durability -= power
        if durability <= 0 {
            type = .empty
            durability = 0
        }
    }
}
