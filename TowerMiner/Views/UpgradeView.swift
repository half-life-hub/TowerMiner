import SwiftUI

struct UpgradeView: View {
    let profile: PlayerProfile
    let onPurchase: (UpgradeID) -> Void
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

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(UpgradeID.allCases) { upgrade in
                            UpgradePurchaseRow(
                                upgrade: upgrade,
                                level: profile.level(for: upgrade),
                                credits: profile.totalCredits,
                                onPurchase: onPurchase
                            )
                        }
                    }
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

private struct UpgradePurchaseRow: View {
    let upgrade: UpgradeID
    let level: Int
    let credits: Int
    let onPurchase: (UpgradeID) -> Void

    private var isMaxed: Bool {
        level >= upgrade.maxLevel
    }

    private var cost: Int {
        upgrade.cost(for: level)
    }

    private var canPurchase: Bool {
        !isMaxed && credits >= cost
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(upgrade.title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                    Text(upgrade.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.66))
                }
                Spacer()
                Text("Lv \(level)/\(upgrade.maxLevel)")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            }

            Button(isMaxed ? "Maxed" : "Buy \(cost)") {
                onPurchase(upgrade)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canPurchase)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    UpgradeView(
        profile: PlayerProfile(
            totalCredits: 100,
            bestDepth: 0,
            maxHealthLevel: 0,
            maxEnergyLevel: 1,
            startingBombsLevel: 0,
            startingShieldsLevel: 0,
            gemValueLevel: 0
        ),
        onPurchase: { _ in },
        onBack: {}
    )
}
