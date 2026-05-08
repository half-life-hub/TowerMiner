import Foundation

struct MineGenerator {
    let columns: Int
    let seed: UInt64

    func makeInitialRows(count: Int, startColumn: Int) -> [[MineTile]] {
        (0..<count).map { depth in
            makeRow(depth: depth, startColumn: startColumn)
        }
    }

    func makeRows(from startDepth: Int, count: Int, startColumn: Int) -> [[MineTile]] {
        (startDepth..<(startDepth + count)).map { depth in
            makeRow(depth: depth, startColumn: startColumn)
        }
    }

    func makeRow(depth: Int, startColumn: Int) -> [MineTile] {
        var row = (0..<columns).map { column in
            MineTile(type: tileType(depth: depth, column: column, startColumn: startColumn))
        }

        let pathColumn = pathColumn(for: depth, startColumn: startColumn)
        row[pathColumn] = MineTile(type: depth <= 3 ? .empty : .dirt)

        if depth == 0 {
            return Array(repeating: MineTile(type: .empty), count: columns)
        }

        return row
    }

    private func tileType(depth: Int, column: Int, startColumn: Int) -> TileType {
        if depth <= 3 {
            let distanceFromStart = abs(column - startColumn)
            return distanceFromStart <= 1 ? .empty : .dirt
        }

        let roll = randomPercent(depth: depth, column: column)

        switch depth {
        case 0...20:
            if roll < 8 {
                return .empty
            } else if roll < 13 {
                return .gold
            } else if roll < 16 {
                return .gem
            } else if roll < 24 {
                return .stone
            } else {
                return .dirt
            }
        case 21...50:
            if roll < 6 {
                return .empty
            } else if roll < 12 {
                return .gold
            } else if roll < 17 {
                return .gem
            } else if roll < 19 {
                return .chest
            } else if roll < 24 {
                return .spike
            } else if roll < 43 {
                return .stone
            } else if roll < 54 {
                return .hardStone
            } else {
                return .dirt
            }
        default:
            if roll < 5 {
                return .empty
            } else if roll < 11 {
                return .gold
            } else if roll < 17 {
                return .gem
            } else if roll < 20 {
                return .chest
            } else if roll < 25 {
                return .spike
            } else if roll < 30 {
                return .lava
            } else if roll < 48 {
                return .stone
            } else if roll < 62 {
                return .hardStone
            } else {
                return .dirt
            }
        }
    }

    private func pathColumn(for depth: Int, startColumn: Int) -> Int {
        let pattern = [0, 0, 1, 1, 2, 2, 1, 1, 0, 0, -1, -1, -2, -2, -1, -1]
        let phase = Int(seed % UInt64(pattern.count))
        let offset = pattern[(depth + phase) % pattern.count]
        return min(max(startColumn + offset, 0), columns - 1)
    }

    private func randomPercent(depth: Int, column: Int) -> Int {
        Int(mixedValue(depth: depth, column: column, salt: 17) % 100)
    }

    private func mixedValue(depth: Int, column: Int = 0, salt: UInt64) -> UInt64 {
        var value = seed
        value &+= UInt64(depth) &* 0x9E3779B185EBCA87
        value &+= UInt64(column + 1) &* 0xC2B2AE3D27D4EB4F
        value &+= salt &* 0x165667B19E3779F9
        value ^= value >> 30
        value &*= 0xBF58476D1CE4E5B9
        value ^= value >> 27
        value &*= 0x94D049BB133111EB
        value ^= value >> 31
        return value
    }
}
