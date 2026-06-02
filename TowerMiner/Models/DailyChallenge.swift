import Foundation

struct DailyChallenge: Codable, Equatable {
    let dateKey: String
    let seed: UInt64

    var displayTitle: String {
        "Daily Mine \(dateKey)"
    }

    var targetDepth: Int {
        40
    }

    var bonusCredits: Int {
        25
    }

    var goalDescription: String {
        "Reach depth \(targetDepth)"
    }

    func isCompleted(by result: RunResult) -> Bool {
        result.depth >= targetDepth
    }

    static func today(calendar: Calendar = .autoupdatingCurrent, now: Date = Date()) -> DailyChallenge {
        let dateKey = makeDateKey(for: now, calendar: calendar)
        return DailyChallenge(dateKey: dateKey, seed: makeSeed(from: dateKey))
    }

    static func makeDateKey(for date: Date, calendar: Calendar = .autoupdatingCurrent) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 2_026
        let month = components.month ?? 1
        let day = components.day ?? 1
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    static func makeSeed(from dateKey: String) -> UInt64 {
        var hash: UInt64 = 0xcbf29ce484222325

        for byte in dateKey.utf8 {
            hash ^= UInt64(byte)
            hash &*= 0x100000001b3
        }

        return hash
    }
}

struct DailyChallengeRecord: Codable, Equatable, Identifiable {
    let dateKey: String
    var bestDepth: Int
    var bestPayout: Int
    var attempts: Int

    var id: String {
        dateKey
    }

    static func empty(for challenge: DailyChallenge) -> DailyChallengeRecord {
        DailyChallengeRecord(dateKey: challenge.dateKey, bestDepth: 0, bestPayout: 0, attempts: 0)
    }

    mutating func apply(_ result: RunResult) {
        bestDepth = max(bestDepth, result.depth)
        bestPayout = max(bestPayout, result.totalPayout)
        attempts += 1
    }
}
