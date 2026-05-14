import SwiftUI

struct UpgradeView: View {
    let profile: PlayerProfile
    let onPurchase: (UpgradeID) -> Void
    let onBack: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = min(geometry.size.width - 32, 720)

            ZStack {
                UpgradeScreenBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        header
                        creditPanel

                        ForEach(UpgradeID.allCases) { upgrade in
                            UpgradePurchaseRow(
                                upgrade: upgrade,
                                level: profile.level(for: upgrade),
                                credits: profile.totalCredits,
                                onPurchase: onPurchase
                            )
                        }
                    }
                    .frame(width: contentWidth)
                    .padding(.top, 70)
                    .padding(.bottom, 28)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.never, axes: .vertical)

                Button(action: onBack) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .black))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                }
                .buttonStyle(UpgradeCloseButtonStyle())
                .padding(.top, 14)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .accessibilityLabel("Close upgrades")
            }
            .persistentSystemOverlays(.hidden)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.30), radius: 14)
                .accessibilityLabel("Tower Miner")

            Text("Rig Upgrades")
                .font(.title.bold())
                .foregroundStyle(.white)

            Text("Spend banked credits to push deeper on the next run.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.70))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black.opacity(0.34))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
    }

    private var creditPanel: some View {
        HStack(spacing: 14) {
            UpgradeSymbolBadge(symbol: "creditcard.fill", tint: Color(red: 1.0, green: 0.78, blue: 0.23))

            VStack(alignment: .leading, spacing: 3) {
                Text("Available Credits")
                    .font(.caption.weight(.black))
                    .tracking(0.8)
                    .foregroundStyle(.white.opacity(0.60))

                Text("\(profile.totalCredits)")
                    .font(.largeTitle.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
            }

            Spacer()
        }
        .padding(.leading, 28)
        .padding(.trailing, 20)
        .padding(.vertical, 16)
        .background {
            UpgradePanelBackground(cornerRadius: 18)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color(red: 1.0, green: 0.78, blue: 0.23).opacity(0.36), lineWidth: 1)
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
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                UpgradeSymbolBadge(symbol: upgrade.symbol, tint: upgrade.tint)

                VStack(alignment: .leading, spacing: 4) {
                    Text(upgrade.title)
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)

                    Text(upgrade.description)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.66))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                Text("LV \(level)/\(upgrade.maxLevel)")
                    .font(.caption.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white.opacity(0.86))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.32), in: Capsule())
            }

            UpgradeLevelMeter(level: level, maxLevel: upgrade.maxLevel, tint: upgrade.tint)

            HStack(spacing: 12) {
                Text(statusText)
                    .font(.caption.weight(.black))
                    .tracking(0.4)
                    .foregroundStyle(statusColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Spacer(minLength: 8)

                Button {
                    onPurchase(upgrade)
                } label: {
                    HStack(spacing: 6) {
                        Text(isMaxed ? "MAX" : "BUY")
                            .font(.caption.weight(.black))
                            .tracking(0.8)

                        if !isMaxed {
                            Text("\(cost)")
                                .font(.headline.weight(.black))
                                .monospacedDigit()
                        }
                    }
                    .frame(minWidth: 108, minHeight: 46)
                }
                .buttonStyle(UpgradeBuyButtonStyle(tint: upgrade.tint, isEnabled: canPurchase, isMaxed: isMaxed))
                .disabled(!canPurchase)
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 18)
        .padding(.vertical, 14)
        .background {
            UpgradePanelBackground(cornerRadius: 18)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.20),
                            upgrade.tint.opacity(canPurchase ? 0.62 : 0.26),
                            .black.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.24), radius: 12, y: 8)
    }

    private var statusText: String {
        if isMaxed {
            return "FULLY UPGRADED"
        }

        if canPurchase {
            return "READY TO INSTALL"
        }

        return "NEED \(cost - credits) MORE"
    }

    private var statusColor: Color {
        if isMaxed {
            return .white.opacity(0.62)
        }

        return canPurchase ? upgrade.tint : .white.opacity(0.42)
    }
}

private struct UpgradeLevelMeter: View {
    let level: Int
    let maxLevel: Int
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<maxLevel, id: \.self) { index in
                Capsule()
                    .fill(index < level ? tint : Color.white.opacity(0.12))
                    .frame(maxWidth: .infinity)
                    .frame(height: 7)
                    .overlay {
                        Capsule()
                            .stroke(.white.opacity(index < level ? 0.28 : 0.08), lineWidth: 1)
                    }
            }
        }
    }
}

private struct UpgradeSymbolBadge: View {
    let symbol: String
    let tint: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.88), tint.opacity(0.34), Color.black.opacity(0.42)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: symbol)
                .font(.system(size: 23, weight: .black))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
        }
        .frame(width: 54, height: 54)
        .overlay {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(.white.opacity(0.22), lineWidth: 1)
        }
        .shadow(color: tint.opacity(0.18), radius: 10, y: 5)
    }
}

private struct UpgradePanelBackground: View {
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.16, green: 0.17, blue: 0.18).opacity(0.84),
                            Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.94)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: cornerRadius - 2, style: .continuous)
                .strokeBorder(Color.white.opacity(0.05), lineWidth: 4)
                .padding(5)

            HStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.08))
                    .frame(width: 5)
                    .padding(.vertical, 14)

                Spacer()

                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.05))
                    .frame(width: 5)
                    .padding(.vertical, 14)
            }
            .padding(.horizontal, 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

private struct UpgradeBuyButtonStyle: ButtonStyle {
    let tint: Color
    let isEnabled: Bool
    let isMaxed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled || isMaxed ? .white : .white.opacity(0.42))
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: isMaxed
                                ? [Color.white.opacity(0.18), Color.white.opacity(0.07)]
                                : [
                                    tint.opacity(isEnabled ? 0.84 : 0.18),
                                    tint.opacity(isEnabled ? 0.32 : 0.08),
                                    Color.black.opacity(0.48)
                                ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .strokeBorder(.white.opacity(isEnabled ? 0.30 : 0.10), lineWidth: 1)
            }
            .brightness(configuration.isPressed ? -0.06 : 0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct UpgradeCloseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.18, green: 0.19, blue: 0.20),
                                Color(red: 0.05, green: 0.06, blue: 0.08),
                                Color(red: 0.12, green: 0.09, blue: 0.07)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                Circle()
                    .strokeBorder(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.56), lineWidth: 1.5)
            }
            .shadow(color: .black.opacity(0.32), radius: 10, y: 6)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct UpgradeScreenBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.06, green: 0.08, blue: 0.14), Color(red: 0.18, green: 0.08, blue: 0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { column in
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(.white.opacity((row + column).isMultiple(of: 3) ? 0.024 : 0.015), lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color(red: 0.25, green: 0.16, blue: 0.10).opacity((row + column).isMultiple(of: 4) ? 0.10 : 0.04))
                                )
                                .frame(height: 74)
                        }
                    }
                }
            }
            .opacity(0.55)
            .blur(radius: 0.3)
            .ignoresSafeArea()
        }
    }
}

private extension UpgradeID {
    var symbol: String {
        switch self {
        case .maxHealth:
            return "heart.fill"
        case .maxEnergy:
            return "bolt.fill"
        case .startingBombs:
            return "flame.fill"
        case .startingShields:
            return "shield.fill"
        case .gemValue:
            return "diamond.fill"
        }
    }

    var tint: Color {
        switch self {
        case .maxHealth:
            return Color(red: 1.0, green: 0.32, blue: 0.28)
        case .maxEnergy:
            return Color(red: 0.44, green: 0.78, blue: 1.0)
        case .startingBombs:
            return Color(red: 1.0, green: 0.45, blue: 0.16)
        case .startingShields:
            return Color(red: 0.52, green: 0.94, blue: 0.86)
        case .gemValue:
            return Color(red: 0.82, green: 0.58, blue: 1.0)
        }
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
