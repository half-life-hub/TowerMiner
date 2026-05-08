import Foundation

struct PlayerState: Equatable {
    var position: GridPosition
    var maxHealth: Int
    var health: Int
    var maxEnergy: Int
    var energy: Int
    var coins: Int
    var gems: Int
    var bombs: Int
    var shields: Int
    var activeShieldHits: Int
}
