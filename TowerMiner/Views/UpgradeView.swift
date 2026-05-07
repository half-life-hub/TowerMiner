import SwiftUI

struct UpgradeView: View {
    let profile: PlayerProfile
    let onBack: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.07, blue: 0.12), Color(red: 0.12, green: 0.08, blue: 0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Upgrades")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Back", action: onBack)
                        .buttonStyle(.borderedProminent)
                }

                Text("Credits: \(profile.totalCredits)")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.88))

                VStack(spacing: 12) {
                    UpgradePreviewRow(title: "Max Health", level: profile.maxHealthLevel)
                    UpgradePreviewRow(title: "Max Energy", level: profile.maxEnergyLevel)
                    UpgradePreviewRow(title: "Starting Bombs", level: profile.startingBombsLevel)
                    UpgradePreviewRow(title: "Starting Shields", level: profile.startingShieldsLevel)
                    UpgradePreviewRow(title: "Gem Value", level: profile.gemValueLevel)
                }

                Text("Purchasing upgrades lands in Milestone 5.")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.72))

                Spacer()
            }
            .padding(24)
        }
    }
}

private struct UpgradePreviewRow: View {
    let title: String
    let level: Int

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.76))
            Spacer()
            Text("Level \(level)")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    UpgradeView(profile: .default, onBack: {})
}
