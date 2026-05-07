import Foundation

struct PlayerState: Equatable {
    var position: GridPosition
    var health: Int
    var energy: Int
    var bombs: Int
    var shields: Int
}
