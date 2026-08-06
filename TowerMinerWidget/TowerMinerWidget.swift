//
//  TowerMinerWidget.swift
//  TowerMinerWidget
//
//  Created by Steven Marshall on 6/8/2026.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DailyChallengeEntry {
        DailyChallengeEntry.sample
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyChallengeEntry) -> Void) {
        completion(DailyChallengeEntry(date: .now, challenge: .challenge(for: .now)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyChallengeEntry>) -> Void) {
        let currentDate = Date()
        let entry = DailyChallengeEntry(date: currentDate, challenge: .challenge(for: currentDate))
        let tomorrow = Calendar.current.startOfDay(for: currentDate.addingTimeInterval(86_400))
        completion(Timeline(entries: [entry], policy: .after(tomorrow)))
    }
}

struct DailyChallengeEntry: TimelineEntry {
    let date: Date
    let challenge: WidgetDailyChallenge

    static let sample = DailyChallengeEntry(
        date: .now,
        challenge: WidgetDailyChallenge(
            id: "depth-150-gems-9",
            title: "Core Seeker",
            goalText: "Reach depth 150",
            rewardText: "+9 gems"
        )
    )
}

struct WidgetDailyChallenge {
    let id: String
    let title: String
    let goalText: String
    let rewardText: String

    static func challenge(for date: Date, calendar: Calendar = .current) -> WidgetDailyChallenge {
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return rotation[day % rotation.count]
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
        HStack(alignment: .center, spacing: 16) {
            challengePanel
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 10) {
                rewardBadge
                deepLinkButton(title: "Start", systemImage: "arrow.down.circle.fill", destination: .startChallenge)
            }
            .frame(width: 112, alignment: .leading)
        }
        .padding(18)
    }

    private var largeLayout: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                challengePanel
                    .frame(maxWidth: .infinity, alignment: .leading)

                rewardBadge
            }

            HStack(spacing: 10) {
                deepLinkButton(title: "Start Challenge", systemImage: "arrow.down.circle.fill", destination: .startChallenge)
                deepLinkButton(title: "Upgrade Rig", systemImage: "wrench.and.screwdriver.fill", destination: .upgrades)
            }

            minePreview
        }
        .padding(20)
    }

    private var challengePanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Daily Challenge", systemImage: "calendar.badge.clock")
                .font(.caption.weight(.black))
                .foregroundStyle(Color(red: 0.92, green: 0.63, blue: 1.00))
                .lineLimit(1)

            Text(entry.challenge.title)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.74)

            Text(entry.challenge.goalText)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white.opacity(0.68))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
    }

    private var rewardBadge: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 20, weight: .black))
                .foregroundStyle(Color(red: 0.47, green: 0.92, blue: 1.00))

            Text(entry.challenge.rewardText)
                .font(.headline.weight(.black))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text("Reward")
                .font(.caption2.weight(.black))
                .foregroundStyle(.white.opacity(0.56))
                .textCase(.uppercase)
        }
        .padding(12)
        .frame(minWidth: 92, alignment: .leading)
        .background(Color.black.opacity(0.26), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
    }

    private func deepLinkButton(title: String, systemImage: String, destination: WidgetDeepLink) -> some View {
        Link(destination: destination.url) {
            Label(title, systemImage: systemImage)
                .font(.caption.weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.74)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, minHeight: 34)
                .padding(.horizontal, 8)
                .background(Color(red: 0.51, green: 0.94, blue: 0.86), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }

    private var minePreview: some View {
        HStack(spacing: 5) {
            ForEach(0..<7, id: \.self) { column in
                VStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { row in
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(tileColor(row: row, column: column))
                            .overlay {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .stroke(.white.opacity(0.08), lineWidth: 1)
                            }
                    }
                }
            }
        }
        .frame(height: 74)
    }

    private var mineBackground: some View {
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

    private func tileColor(row: Int, column: Int) -> Color {
        switch (row + column) % 6 {
        case 0:
            return Color(red: 0.25, green: 0.16, blue: 0.10)
        case 1:
            return Color(red: 0.35, green: 0.25, blue: 0.16)
        case 2:
            return Color(red: 0.18, green: 0.19, blue: 0.22)
        case 3:
            return Color(red: 0.48, green: 0.30, blue: 0.13)
        case 4:
            return Color(red: 0.09, green: 0.36, blue: 0.38)
        default:
            return Color(red: 0.40, green: 0.11, blue: 0.08)
        }
    }
}

private enum WidgetDeepLink {
    case startChallenge
    case upgrades

    var url: URL {
        switch self {
        case .startChallenge:
            return URL(string: "towerminer://daily-challenge")!
        case .upgrades:
            return URL(string: "towerminer://upgrades")!
        }
    }
}

struct TowerMinerWidget: Widget {
    let kind: String = "TowerMinerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TowerMinerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Tower Miner")
        .description("Track mining progress and today's challenge.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview("Medium", as: .systemMedium) {
    TowerMinerWidget()
} timeline: {
    DailyChallengeEntry.sample
}

#Preview("Large", as: .systemLarge) {
    TowerMinerWidget()
} timeline: {
    DailyChallengeEntry.sample
}
