import Foundation

struct DailyChallenge: Equatable {
    enum Goal: Equatable {
        case reachDepth(Int)
    }

    enum Reward: Equatable {
        case gems(Int)
    }

    let id: String
    let title: String
    let goal: Goal
    let reward: Reward

    var goalText: String {
        switch goal {
        case .reachDepth(let depth):
            return "Reach depth \(depth)"
        }
    }

    var rewardText: String {
        switch reward {
        case .gems(let count):
            return "+\(count) gems"
        }
    }

    var gemReward: Int {
        switch reward {
        case .gems(let count):
            return count
        }
    }

    func isCompleted(depth: Int) -> Bool {
        switch goal {
        case .reachDepth(let requiredDepth):
            return depth >= requiredDepth
        }
    }

    func completionKey(for date: Date = Date(), calendar: Calendar = .current) -> String {
        "\(Self.dayKey(for: date, calendar: calendar)):\(id)"
    }

    static func challenge(for date: Date = Date(), calendar: Calendar = .current) -> DailyChallenge {
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return rotation[day % rotation.count]
    }

    static func dayKey(for date: Date = Date(), calendar: Calendar = .current) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    private static let rotation = [
        DailyChallenge(id: "depth-100-gems-5", title: "Deep Descent", goal: .reachDepth(100), reward: .gems(5)),
        DailyChallenge(id: "depth-75-gems-3", title: "Steady Drill", goal: .reachDepth(75), reward: .gems(3)),
        DailyChallenge(id: "depth-125-gems-7", title: "Pressure Dive", goal: .reachDepth(125), reward: .gems(7))
    ]
}
