//
//  TowerMinerWidget.swift
//  TowerMinerWidget
//
//  Created by Steven Marshall on 6/8/2026.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MineStatusEntry {
        MineStatusEntry.sample
    }

    func getSnapshot(in context: Context, completion: @escaping (MineStatusEntry) -> Void) {
        completion(.sample)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MineStatusEntry>) -> Void) {
        let entry = MineStatusEntry.sample
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: entry.date) ?? entry.date
        completion(Timeline(entries: [entry], policy: .after(nextRefreshDate)))
    }
}

struct MineStatusEntry: TimelineEntry {
    let date: Date
    let depth: Int
    let coins: Int
    let gems: Int
    let bestDepth: Int
    let challengeTitle: String
    let challengeProgress: Double

    static let sample = MineStatusEntry(
        date: .now,
        depth: 128,
        coins: 420,
        gems: 12,
        bestDepth: 215,
        challengeTitle: "Core Seeker",
        challengeProgress: 0.64
    )
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
        HStack(spacing: 16) {
            depthPanel
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 10) {
                statRow(title: "Coins", value: "\(entry.coins)", systemImage: "bitcoinsign.circle.fill", tint: Color(red: 0.98, green: 0.78, blue: 0.26))
                statRow(title: "Gems", value: "\(entry.gems)", systemImage: "diamond.fill", tint: Color(red: 0.47, green: 0.92, blue: 1.00))
                challengeProgress
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
    }

    private var largeLayout: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 18) {
                depthPanel
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 10) {
                    statRow(title: "Coins", value: "\(entry.coins)", systemImage: "bitcoinsign.circle.fill", tint: Color(red: 0.98, green: 0.78, blue: 0.26))
                    statRow(title: "Gems", value: "\(entry.gems)", systemImage: "diamond.fill", tint: Color(red: 0.47, green: 0.92, blue: 1.00))
                    statRow(title: "Best", value: "\(entry.bestDepth)m", systemImage: "flag.checkered", tint: Color(red: 0.99, green: 0.42, blue: 0.32))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            challengeProgress

            minePreview
        }
        .padding(20)
    }

    private var depthPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Tower Miner", systemImage: "mountain.2.fill")
                .font(.caption.weight(.black))
                .foregroundStyle(Color(red: 0.51, green: 0.94, blue: 0.86))
                .lineLimit(1)

            Text("\(entry.depth)m")
                .font(.system(size: 42, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("Current depth")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.68))
                .lineLimit(1)
        }
    }

    private var challengeProgress: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(Color(red: 0.92, green: 0.63, blue: 1.00))

                Text(entry.challengeTitle)
                    .font(.caption.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            ProgressView(value: entry.challengeProgress)
                .tint(Color(red: 0.92, green: 0.63, blue: 1.00))
        }
    }

    private func statRow(title: String, value: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(tint)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.headline.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(title.uppercased())
                    .font(.caption2.weight(.black))
                    .foregroundStyle(.white.opacity(0.56))
                    .lineLimit(1)
            }
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
    MineStatusEntry.sample
}

#Preview("Large", as: .systemLarge) {
    TowerMinerWidget()
} timeline: {
    MineStatusEntry.sample
}
