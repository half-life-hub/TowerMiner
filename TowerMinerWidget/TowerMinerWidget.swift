//
//  TowerMinerWidget.swift
//  TowerMinerWidget
//
//  Created by Steven Marshall on 6/8/2026.
//

import SwiftUI
import WidgetKit

private let appGroupID = "group.au.tower.miner"
private let profileKey = "towerminer.playerProfile"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TowerMinerWidgetEntry {
        .sample
    }

    func getSnapshot(in context: Context, completion: @escaping (TowerMinerWidgetEntry) -> Void) {
        completion(context.isPreview ? .sample : Self.makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TowerMinerWidgetEntry>) -> Void) {
        let entry = Self.makeEntry()
        let tomorrow = Calendar.current.startOfDay(for: entry.date.addingTimeInterval(86_400))
        completion(Timeline(entries: [entry], policy: .after(tomorrow)))
    }

    private static func makeEntry(date: Date = Date()) -> TowerMinerWidgetEntry {
        let profile = WidgetProfile.load()
        let challenge = WidgetDailyChallenge.challenge(for: date)
        let recommendation = WidgetUpgradeRecommendation.bestRecommendation(for: profile)
        let isChallengeComplete = profile.completedDailyChallengeKey == challenge.completionKey(for: date)

        return TowerMinerWidgetEntry(
            date: date,
            profile: profile,
            challenge: challenge,
            isChallengeComplete: isChallengeComplete,
            upgradeRecommendation: recommendation
        )
    }
}

struct TowerMinerWidgetEntry: TimelineEntry {
    let date: Date
    let profile: WidgetProfile
    let challenge: WidgetDailyChallenge
    let isChallengeComplete: Bool
    let upgradeRecommendation: WidgetUpgradeRecommendation

    static let sample = TowerMinerWidgetEntry(
        date: .now,
        profile: .sample,
        challenge: WidgetDailyChallenge(
            id: "depth-150-gems-9",
            title: "Core Seeker",
            goalText: "Reach depth 150",
            rewardText: "+9 gems"
        ),
        isChallengeComplete: false,
        upgradeRecommendation: WidgetUpgradeRecommendation(
            title: "Max Energy",
            currentLevel: 1,
            maxLevel: 5,
            cost: 128,
            creditsAvailable: 180
        )
    )
}

struct WidgetProfile: Decodable {
    let totalCredits: Int
    let bestDepth: Int
    let totalRuns: Int
    let lifetimeGemsCollected: Int
    let maxHealthLevel: Int
    let maxEnergyLevel: Int
    let startingBombsLevel: Int
    let startingShieldsLevel: Int
    let gemValueLevel: Int
    let completedDailyChallengeKey: String?

    var rigLevel: Int {
        maxHealthLevel + maxEnergyLevel + startingBombsLevel + startingShieldsLevel + gemValueLevel
    }

    var gemValue: Int {
        5 + gemValueLevel * 2
    }

    enum CodingKeys: String, CodingKey {
        case totalCredits
        case bestDepth
        case totalRuns
        case lifetimeGemsCollected
        case maxHealthLevel
        case maxEnergyLevel
        case startingBombsLevel
        case startingShieldsLevel
        case gemValueLevel
        case completedDailyChallengeKey
    }

    static let sample = WidgetProfile(
        totalCredits: 180,
        bestDepth: 215,
        totalRuns: 12,
        lifetimeGemsCollected: 46,
        maxHealthLevel: 2,
        maxEnergyLevel: 1,
        startingBombsLevel: 1,
        startingShieldsLevel: 0,
        gemValueLevel: 1,
        completedDailyChallengeKey: nil
    )

    static let empty = WidgetProfile(
        totalCredits: 0,
        bestDepth: 0,
        totalRuns: 0,
        lifetimeGemsCollected: 0,
        maxHealthLevel: 0,
        maxEnergyLevel: 0,
        startingBombsLevel: 0,
        startingShieldsLevel: 0,
        gemValueLevel: 0,
        completedDailyChallengeKey: nil
    )

    init(
        totalCredits: Int,
        bestDepth: Int,
        totalRuns: Int,
        lifetimeGemsCollected: Int,
        maxHealthLevel: Int,
        maxEnergyLevel: Int,
        startingBombsLevel: Int,
        startingShieldsLevel: Int,
        gemValueLevel: Int,
        completedDailyChallengeKey: String?
    ) {
        self.totalCredits = totalCredits
        self.bestDepth = bestDepth
        self.totalRuns = totalRuns
        self.lifetimeGemsCollected = lifetimeGemsCollected
        self.maxHealthLevel = maxHealthLevel
        self.maxEnergyLevel = maxEnergyLevel
        self.startingBombsLevel = startingBombsLevel
        self.startingShieldsLevel = startingShieldsLevel
        self.gemValueLevel = gemValueLevel
        self.completedDailyChallengeKey = completedDailyChallengeKey
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCredits = try container.decodeIfPresent(Int.self, forKey: .totalCredits) ?? 0
        bestDepth = try container.decodeIfPresent(Int.self, forKey: .bestDepth) ?? 0
        totalRuns = try container.decodeIfPresent(Int.self, forKey: .totalRuns) ?? 0
        lifetimeGemsCollected = try container.decodeIfPresent(Int.self, forKey: .lifetimeGemsCollected) ?? 0
        maxHealthLevel = try container.decodeIfPresent(Int.self, forKey: .maxHealthLevel) ?? 0
        maxEnergyLevel = try container.decodeIfPresent(Int.self, forKey: .maxEnergyLevel) ?? 0
        startingBombsLevel = try container.decodeIfPresent(Int.self, forKey: .startingBombsLevel) ?? 0
        startingShieldsLevel = try container.decodeIfPresent(Int.self, forKey: .startingShieldsLevel) ?? 0
        gemValueLevel = try container.decodeIfPresent(Int.self, forKey: .gemValueLevel) ?? 0
        completedDailyChallengeKey = try container.decodeIfPresent(String.self, forKey: .completedDailyChallengeKey)
    }

    static func load() -> WidgetProfile {
        guard let defaults = UserDefaults(suiteName: appGroupID),
              let data = defaults.data(forKey: profileKey),
              let profile = try? JSONDecoder().decode(WidgetProfile.self, from: data) else {
            return .empty
        }

        return profile
    }
}

struct WidgetDailyChallenge {
    let id: String
    let title: String
    let goalText: String
    let rewardText: String

    func completionKey(for date: Date, calendar: Calendar = .current) -> String {
        "\(Self.dayKey(for: date, calendar: calendar)):\(id)"
    }

    static func challenge(for date: Date, calendar: Calendar = .current) -> WidgetDailyChallenge {
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return rotation[day % rotation.count]
    }

    static func dayKey(for date: Date, calendar: Calendar = .current) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    private static let rotation = [
        WidgetDailyChallenge(id: "depth-100-gems-5", title: "Deep Descent", goalText: "Reach depth 100", rewardText: "+5 gems"),
        WidgetDailyChallenge(id: "depth-75-gems-3", title: "Steady Drill", goalText: "Reach depth 75", rewardText: "+3 gems"),
        WidgetDailyChallenge(id: "depth-125-gems-7", title: "Pressure Dive", goalText: "Reach depth 125", rewardText: "+7 gems"),
        WidgetDailyChallenge(id: "depth-50-gems-2", title: "Quick Drop", goalText: "Reach depth 50", rewardText: "+2 gems"),
        WidgetDailyChallenge(id: "depth-150-gems-9", title: "Core Seeker", goalText: "Reach depth 150", rewardText: "+9 gems"),
        WidgetDailyChallenge(id: "depth-90-gems-4", title: "Narrow Descent", goalText: "Reach depth 90", rewardText: "+4 gems"),
        WidgetDailyChallenge(id: "depth-175-gems-11", title: "Bedrock Push", goalText: "Reach depth 175", rewardText: "+11 gems"),
        WidgetDailyChallenge(id: "depth-60-gems-3", title: "Fast Shaft", goalText: "Reach depth 60", rewardText: "+3 gems"),
        WidgetDailyChallenge(id: "depth-200-gems-14", title: "Abyss Run", goalText: "Reach depth 200", rewardText: "+14 gems"),
        WidgetDailyChallenge(id: "depth-110-gems-6", title: "Deep Cut", goalText: "Reach depth 110", rewardText: "+6 gems")
    ]
}

struct WidgetUpgradeRecommendation {
    let title: String
    let currentLevel: Int
    let maxLevel: Int
    let cost: Int
    let creditsAvailable: Int

    var isAffordable: Bool {
        creditsAvailable >= cost
    }

    var remainingCredits: Int {
        max(0, cost - creditsAvailable)
    }

    var statusText: String {
        if title == "Rig Complete" {
            return "All upgrades maxed"
        }

        if isAffordable {
            return "Ready to buy"
        }

        return "Need \(Self.compact(remainingCredits)) more"
    }

    static func bestRecommendation(for profile: WidgetProfile) -> WidgetUpgradeRecommendation {
        let candidates = WidgetUpgrade.allCases.compactMap { upgrade -> WidgetUpgradeRecommendation? in
            let level = upgrade.level(in: profile)
            guard level < upgrade.maxLevel else {
                return nil
            }

            return WidgetUpgradeRecommendation(
                title: upgrade.title,
                currentLevel: level,
                maxLevel: upgrade.maxLevel,
                cost: upgrade.cost(for: level),
                creditsAvailable: profile.totalCredits
            )
        }

        if let affordable = candidates.filter(\.isAffordable).min(by: { $0.cost < $1.cost }) {
            return affordable
        }

        if let closest = candidates.min(by: { $0.remainingCredits < $1.remainingCredits }) {
            return closest
        }

        return WidgetUpgradeRecommendation(
            title: "Rig Complete",
            currentLevel: profile.rigLevel,
            maxLevel: profile.rigLevel,
            cost: 0,
            creditsAvailable: profile.totalCredits
        )
    }

    private static func compact(_ value: Int) -> String {
        WidgetNumberFormatting.compact(value)
    }
}

private enum WidgetUpgrade: CaseIterable {
    case maxHealth
    case maxEnergy
    case startingBombs
    case startingShields
    case gemValue

    var title: String {
        switch self {
        case .maxHealth:
            return "Max Health"
        case .maxEnergy:
            return "Max Energy"
        case .startingBombs:
            return "Starting Bombs"
        case .startingShields:
            return "Starting Shields"
        case .gemValue:
            return "Gem Value"
        }
    }

    var maxLevel: Int {
        switch self {
        case .maxHealth, .maxEnergy:
            return 5
        case .startingBombs, .startingShields, .gemValue:
            return 3
        }
    }

    var baseCost: Int {
        switch self {
        case .maxHealth:
            return 35
        case .maxEnergy:
            return 32
        case .startingBombs:
            return 45
        case .startingShields:
            return 40
        case .gemValue:
            return 55
        }
    }

    func cost(for currentLevel: Int) -> Int {
        baseCost * (currentLevel + 1) * (currentLevel + 1)
    }

    func level(in profile: WidgetProfile) -> Int {
        switch self {
        case .maxHealth:
            return profile.maxHealthLevel
        case .maxEnergy:
            return profile.maxEnergyLevel
        case .startingBombs:
            return profile.startingBombsLevel
        case .startingShields:
            return profile.startingShieldsLevel
        case .gemValue:
            return profile.gemValueLevel
        }
    }
}

struct TowerMinerWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily

    let entry: Provider.Entry

    var body: some View {
        ZStack {
            mineBackground

            switch widgetFamily {
            case .systemLarge:
                largeLayout
            default:
                mediumLayout
            }
        }
    }

    private var mediumLayout: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 7) {
                statBar(title: "Credits", value: WidgetNumberFormatting.compact(entry.profile.totalCredits), systemImage: "creditcard.fill", tint: Color(red: 1.00, green: 0.78, blue: 0.23))
                statBar(title: "Best", value: "\(entry.profile.bestDepth)", systemImage: "arrow.down.to.line.compact", tint: Color(red: 0.51, green: 0.94, blue: 0.86))
            }

            challengePanel(isCompact: true)
        }
        .padding(10)
    }

    private var largeLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                statBar(title: "Credits", value: WidgetNumberFormatting.compact(entry.profile.totalCredits), systemImage: "creditcard.fill", tint: Color(red: 1.00, green: 0.78, blue: 0.23))
                statBar(title: "Best Depth", value: "\(entry.profile.bestDepth)", systemImage: "arrow.down.to.line.compact", tint: Color(red: 0.51, green: 0.94, blue: 0.86))
            }

            largeChallengePanel
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            largeUpgradePanel
        }
        .padding(14)
    }

    private func challengePanel(isCompact: Bool) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: entry.isChallengeComplete ? "checkmark.seal.fill" : "calendar.badge.clock")
                .font(.system(size: isCompact ? 16 : 18, weight: .black))
                .foregroundStyle(entry.isChallengeComplete ? Color(red: 0.62, green: 0.96, blue: 0.46) : Color(red: 0.92, green: 0.63, blue: 1.00))
                .frame(width: isCompact ? 20 : 22)

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.challenge.title)
                    .font(.system(size: isCompact ? 17 : 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)

                Text(entry.isChallengeComplete ? "Completed today" : entry.challenge.goalText)
                    .font((isCompact ? Font.caption2 : Font.caption).weight(.bold))
                    .foregroundStyle(.white.opacity(0.66))
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 2) {
                Text(entry.challenge.rewardText)
                    .font((isCompact ? Font.subheadline : Font.headline).weight(.black))
                    .foregroundStyle(Color(red: 0.47, green: 0.92, blue: 1.00))
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)

                Text("Reward")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(.white.opacity(0.50))
                    .textCase(.uppercase)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, isCompact ? 8 : 11)
        .widgetPanel(tint: Color(red: 0.92, green: 0.63, blue: 1.00))
    }

    private var upgradePanel: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label("Next Upgrade", systemImage: "hammer.fill")
                .font(.caption2.weight(.black))
                .foregroundStyle(Color(red: 1.00, green: 0.78, blue: 0.23))
                .lineLimit(1)

            Text(entry.upgradeRecommendation.title)
                .font(.subheadline.weight(.black))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.68)

            Text("\(WidgetNumberFormatting.compact(entry.upgradeRecommendation.cost)) credits")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.62))
                .lineLimit(1)
                .minimumScaleFactor(0.68)

            Text(entry.upgradeRecommendation.statusText)
                .font(.caption2.weight(.black))
                .foregroundStyle(entry.upgradeRecommendation.isAffordable ? Color(red: 0.62, green: 0.96, blue: 0.46) : .white.opacity(0.50))
                .lineLimit(1)
                .minimumScaleFactor(0.68)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetPanel(tint: Color(red: 1.00, green: 0.78, blue: 0.23))
    }

    private var largeChallengePanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 9) {
                Image(systemName: entry.isChallengeComplete ? "checkmark.seal.fill" : "calendar.badge.clock")
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(entry.isChallengeComplete ? Color(red: 0.62, green: 0.96, blue: 0.46) : Color(red: 0.92, green: 0.63, blue: 1.00))

                Text("Daily Challenge")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.white.opacity(0.72))
                    .textCase(.uppercase)
                    .lineLimit(1)

                Spacer(minLength: 8)

                Text(entry.challenge.rewardText)
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color(red: 0.47, green: 0.92, blue: 1.00))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }

            VStack(spacing: 6) {
                Text(entry.challenge.title)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.62)

                Text(entry.isChallengeComplete ? "Completed today" : entry.challenge.goalText)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.68))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetPanel(tint: Color(red: 0.92, green: 0.63, blue: 1.00))
    }

    private var largeUpgradePanel: some View {
        HStack(spacing: 10) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 18, weight: .black))
                .foregroundStyle(Color(red: 1.00, green: 0.78, blue: 0.23))
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.upgradeRecommendation.title)
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text(entry.upgradeRecommendation.statusText)
                    .font(.caption2.weight(.black))
                    .foregroundStyle(entry.upgradeRecommendation.isAffordable ? Color(red: 0.62, green: 0.96, blue: 0.46) : .white.opacity(0.58))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Spacer(minLength: 8)

            Text("\(WidgetNumberFormatting.compact(entry.upgradeRecommendation.cost)) cr")
                .font(.headline.weight(.black))
                .monospacedDigit()
                .foregroundStyle(Color(red: 1.00, green: 0.78, blue: 0.23))
                .lineLimit(1)
                .minimumScaleFactor(0.68)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .widgetPanel(tint: Color(red: 1.00, green: 0.78, blue: 0.23))
    }

    private func statBar(title: String, value: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                tint.opacity(0.92),
                                tint.opacity(0.36),
                                Color.black.opacity(0.45)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(.white)
            }
            .frame(width: 28, height: 26)

            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.caption.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text(title.uppercased())
                    .font(.caption2.weight(.black))
                    .foregroundStyle(.white.opacity(0.48))
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
            }
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetPanel(tint: tint)
    }

    private var mineBackground: some View {
        WidgetMineBackground()
    }
}

private enum WidgetDeepLink {
    case startChallenge
    case upgrades

    var url: URL {
        var components = URLComponents()
        components.scheme = "towerminer"
        components.host = host
        return components.url ?? URL(fileURLWithPath: "/")
    }

    private var host: String {
        switch self {
        case .startChallenge:
            return "daily-challenge"
        case .upgrades:
            return "upgrades"
        }
    }
}

private enum WidgetNumberFormatting {
    static func compact(_ value: Int) -> String {
        let absoluteValue = abs(value)

        if absoluteValue >= 1_000_000 {
            return "\(value / 1_000_000)M"
        }

        if absoluteValue >= 10_000 {
            return "\(value / 1_000)K"
        }

        return "\(value)"
    }
}

private struct WidgetPanelModifier: ViewModifier {
    let tint: Color

    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.18, green: 0.19, blue: 0.20),
                                    Color(red: 0.06, green: 0.07, blue: 0.09),
                                    Color(red: 0.16, green: 0.10, blue: 0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    tint.opacity(0.70),
                                    tint.opacity(0.18),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 4)
                        .padding(.horizontal, 12)
                        .padding(.top, 6)
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.18),
                                tint.opacity(0.36),
                                .black.opacity(0.34)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
    }
}

private extension View {
    func widgetPanel(tint: Color) -> some View {
        modifier(WidgetPanelModifier(tint: tint))
    }
}

struct TowerMinerWidget: Widget {
    let kind: String = "TowerMinerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TowerMinerWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetMineBackground()
                }
        }
        .configurationDisplayName("Tower Miner")
        .description("Track progress, today's challenge, and the next rig upgrade.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

private struct WidgetMineBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.03, blue: 0.05),
                Color(red: 0.08, green: 0.05, blue: 0.08),
                Color(red: 0.13, green: 0.07, blue: 0.04)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview("Medium", as: .systemMedium) {
    TowerMinerWidget()
} timeline: {
    TowerMinerWidgetEntry.sample
}

#Preview("Large", as: .systemLarge) {
    TowerMinerWidget()
} timeline: {
    TowerMinerWidgetEntry.sample
}
