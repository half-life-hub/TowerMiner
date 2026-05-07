import Foundation

enum TileType: String, CaseIterable {
    case empty
    case dirt
    case stone

    var durability: Int {
        switch self {
        case .empty:
            return 0
        case .dirt:
            return 1
        case .stone:
            return 2
        }
    }

    var isDiggable: Bool {
        self != .empty
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
