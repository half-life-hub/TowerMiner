import SwiftUI

struct ResultsView: View {
    let result: RunResult
    let profile: PlayerProfile
    let onRetry: () -> Void
    let onOpenUpgrades: () -> Void
    let onBackToMenu: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.08, green: 0.09, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Run Results")
                        .font(.largeTitle.weight(.black))
                        .foregroundStyle(.white)

                    VStack(spacing: 12) {
                        ResultRow(title: "Depth", value: "\(result.depth)")
                        ResultRow(title: "Coins", value: "\(result.coins)")
                        ResultRow(title: "Gems", value: "\(result.gems)")
                        ResultRow(title: "Gem Payout", value: "\(result.gemPayout)")
                        ResultRow(title: "Depth Bonus", value: "\(result.depthBonus)")
                        ResultRow(title: "Total Credits", value: "\(result.totalPayout)")
                    }

                    Text("Banked Credits: \(profile.totalCredits)")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.82))

                    VStack(spacing: 12) {
                        Button("Retry", action: onRetry)
                            .buttonStyle(.borderedProminent)
                        Button("Upgrades", action: onOpenUpgrades)
                            .buttonStyle(.bordered)
                        Button("Menu", action: onBackToMenu)
                            .buttonStyle(.borderless)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: 680, alignment: .leading)
                .padding(24)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct ResultRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.72))
            Spacer()
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    ResultsView(
        result: RunResult(depth: 24, coins: 18, gems: 3, gemValue: 5),
        profile: .default,
        onRetry: {},
        onOpenUpgrades: {},
        onBackToMenu: {}
    )
}
