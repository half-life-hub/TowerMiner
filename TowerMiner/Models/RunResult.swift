import Foundation

struct RunResult: Equatable {
    let depth: Int
    let coins: Int
    let gems: Int
    let gemValue: Int
    let dailyChallenge: DailyChallenge?

    init(depth: Int, coins: Int, gems: Int, gemValue: Int, dailyChallenge: DailyChallenge? = nil) {
        self.depth = depth
        self.coins = coins
        self.gems = gems
        self.gemValue = gemValue
        self.dailyChallenge = dailyChallenge
    }

    var isDailyChallenge: Bool {
        dailyChallenge != nil
    }

    var coinPayout: Int {
        coins
    }

    var gemPayout: Int {
        gems * gemValue
    }

    var depthBonus: Int {
        depth / 2
    }

    var dailyChallengeBonus: Int {
        guard let dailyChallenge, dailyChallenge.isCompleted(by: self) else {
            return 0
        }

        return dailyChallenge.bonusCredits
    }

    var totalPayout: Int {
        coinPayout + gemPayout + depthBonus + dailyChallengeBonus
    }
}
