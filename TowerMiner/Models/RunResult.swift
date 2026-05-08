import Foundation

struct RunResult: Equatable {
    let depth: Int
    let coins: Int
    let gems: Int
    let gemValue: Int

    var coinPayout: Int {
        coins
    }

    var gemPayout: Int {
        gems * gemValue
    }

    var depthBonus: Int {
        depth / 2
    }

    var totalPayout: Int {
        coinPayout + gemPayout + depthBonus
    }
}
