import Foundation

struct RunResult: Equatable {
    let depth: Int
    let coins: Int
    let gems: Int
    let gemValue: Int
    let completedDailyChallenge: DailyChallenge?
    let dailyChallengeGemReward: Int

    init(
        depth: Int,
        coins: Int,
        gems: Int,
        gemValue: Int,
        completedDailyChallenge: DailyChallenge? = nil,
        dailyChallengeGemReward: Int = 0
    ) {
        self.depth = depth
        self.coins = coins
        self.gems = gems
        self.gemValue = gemValue
        self.completedDailyChallenge = completedDailyChallenge
        self.dailyChallengeGemReward = dailyChallengeGemReward
    }

    var coinPayout: Int {
        coins
    }

    var totalGems: Int {
        gems + dailyChallengeGemReward
    }

    var gemPayout: Int {
        totalGems * gemValue
    }

    var depthBonus: Int {
        depth / 2
    }

    var totalPayout: Int {
        coinPayout + gemPayout + depthBonus
    }
}
