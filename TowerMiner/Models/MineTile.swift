import Foundation

enum TileType: String, CaseIterable {
    case empty
    case dirt
    case stone
    case hardStone
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
        case .lava, .spike:
            return 0
        }
    }

    var isDiggable: Bool {
        switch self {
        case .dirt, .stone, .hardStone:
            return true
        case .empty, .lava, .spike:
            return false
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
