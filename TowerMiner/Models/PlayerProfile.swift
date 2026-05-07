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
}
