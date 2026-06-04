import SwiftUI

struct ResultsView: View {
    let result: RunResult
    let profile: PlayerProfile
    let isNewBestDepth: Bool
    let onRetry: () -> Void
    let onOpenUpgrades: () -> Void
    let onBackToMenu: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = min(geometry.size.width - 32, 680)

            ZStack {
                ResultsBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        header
                        if isNewBestDepth {
                            newBestDepthCard
                        }
                        if result.completedDailyChallenge != nil {
                            dailyChallengeCard
                        }
                        totalPayoutCard
                        resultGrid
                        bankedCreditsCard
                        actionButtons
                    }
                    .frame(width: contentWidth)
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 310)
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.28), radius: 16)
                .accessibilityLabel("Tower Miner")

            Text("RUN COMPLETE")
                .font(.caption.weight(.black))
                .tracking(2.2)
                .foregroundStyle(Color(red: 0.52, green: 0.94, blue: 0.86))

            Text("Depth \(result.depth)")
                .font(.title3.weight(.black))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.86))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background {
            ResultsPanel(cornerRadius: 22)
        }
    }

    private var totalPayoutCard: some View {
        VStack(spacing: 8) {
            Text("TOTAL CREDITS")
                .font(.caption.weight(.black))
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.58))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .allowsTightening(true)

            HStack(spacing: 12) {
                ResultsCoinIcon()
                    .frame(width: 58, height: 58)

                Text(NumberFormatting.compact(result.totalPayout))
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(red: 1.0, green: 0.78, blue: 0.23), Color(red: 0.84, green: 0.40, blue: 0.10)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.45), radius: 3, y: 2)
                    .accessibilityLabel("Total credits")
                    .accessibilityValue(NumberFormatting.grouped(result.totalPayout))
            }

            Text(result.completedDailyChallenge == nil ? "Coins, gems, and depth bonus banked." : "Coins, gems, daily reward, and depth bonus banked.")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.white.opacity(0.68))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.13, green: 0.15, blue: 0.17).opacity(0.96),
                            Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.98)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.16),
                            Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.24),
                            .black.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.22), radius: 14, y: 8)
    }

    private var newBestDepthCard: some View {
        HStack(spacing: 12) {
            ResultsDepthIcon()
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                Text("NEW BEST")
                    .font(.caption2.weight(.black))
                    .tracking(1.1)
                    .foregroundStyle(Color(red: 0.52, green: 0.94, blue: 0.86))
                    .lineLimit(1)

                Text("Depth \(result.depth)")
                    .font(.title3.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }

            Spacer()
        }
        .padding(14)
        .background {
            ResultsPanel(cornerRadius: 18)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.38), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("New best depth")
        .accessibilityValue("\(result.depth)")
    }

    private var dailyChallengeCard: some View {
        HStack(spacing: 12) {
            ResultsGemIcon()
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                Text("DAILY CHALLENGE")
                    .font(.caption2.weight(.black))
                    .tracking(1.1)
                    .foregroundStyle(Color(red: 0.52, green: 0.94, blue: 0.86))
                    .lineLimit(1)

                Text(result.completedDailyChallenge?.rewardText ?? "")
                    .font(.title3.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }

            Spacer()
        }
        .padding(14)
        .background {
            ResultsPanel(cornerRadius: 18)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.38), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Daily challenge complete")
        .accessibilityValue(result.completedDailyChallenge?.rewardText ?? "")
    }


    private var resultGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ResultStatCard(title: "Coins", value: "\(result.coins)", tint: Color(red: 1.0, green: 0.78, blue: 0.23)) {
                ResultsCoinIcon()
            }

            ResultStatCard(title: "Gems", value: "\(result.totalGems)", tint: Color(red: 0.52, green: 0.94, blue: 0.86)) {
                ResultsGemIcon()
            }

            ResultStatCard(title: "Gem Payout", value: "\(result.gemPayout)", tint: Color(red: 0.52, green: 0.94, blue: 0.86)) {
                ResultsGemIcon()
            }

            ResultStatCard(title: "Depth Bonus", value: "\(result.depthBonus)", tint: Color(red: 0.96, green: 0.56, blue: 0.28)) {
                ResultsDepthIcon()
            }
        }
    }

    private var bankedCreditsCard: some View {
        HStack(spacing: 12) {
            ResultsCoinIcon()
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                Text("BANKED CREDITS")
                    .font(.caption2.weight(.black))
                    .tracking(1.0)
                    .foregroundStyle(.white.opacity(0.55))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .allowsTightening(true)

                Text(NumberFormatting.compact(profile.totalCredits))
                    .font(.title2.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Banked credits")
            .accessibilityValue(NumberFormatting.grouped(profile.totalCredits))

            Spacer()
        }
        .padding(14)
        .background {
            ResultsPanel(cornerRadius: 18)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button(action: onRetry) {
                ResultsActionLabel(title: "Retry Run", systemImage: "arrow.clockwise")
            }
            .buttonStyle(ResultsPrimaryButtonStyle())

            HStack(spacing: 10) {
                Button(action: onOpenUpgrades) {
                    ResultsActionLabel(title: "Upgrades", systemImage: "wrench.and.screwdriver.fill")
                }
                .buttonStyle(ResultsSecondaryButtonStyle(tint: Color(red: 0.52, green: 0.94, blue: 0.86)))

                Button(action: onBackToMenu) {
                    ResultsActionLabel(title: "Menu", systemImage: "house.fill")
                }
                .buttonStyle(ResultsSecondaryButtonStyle(tint: Color(red: 0.96, green: 0.56, blue: 0.28)))
            }
        }
    }
}

private struct ResultStatCard<Icon: View>: View {
    let title: String
    let value: String
    let tint: Color
    let icon: Icon

    init(title: String, value: String, tint: Color, @ViewBuilder icon: () -> Icon) {
        self.title = title
        self.value = value
        self.tint = tint
        self.icon = icon()
    }

    var body: some View {
        HStack(spacing: 9) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.82), tint.opacity(0.26), Color.black.opacity(0.46)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                icon
                    .padding(8)
                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
            }
            .frame(width: 46, height: 46)
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(0.16), lineWidth: 1)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .black))
                    .tracking(0.5)
                    .foregroundStyle(.white.opacity(0.56))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text(value)
                    .font(.title3.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(minHeight: 66)
        .background {
            ResultsPanel(cornerRadius: 16)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.12), tint.opacity(0.32), .black.opacity(0.32)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}

private struct ResultsActionLabel: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .black))

            Text(title.uppercased())
                .font(.caption.weight(.black))
                .tracking(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
    }
}

private struct ResultsPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.82, green: 0.48, blue: 0.16),
                                Color(red: 0.38, green: 0.16, blue: 0.07),
                                Color.black.opacity(0.58)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .strokeBorder(Color(red: 1.0, green: 0.78, blue: 0.23).opacity(0.58), lineWidth: 1.5)
            }
            .shadow(color: Color(red: 1.0, green: 0.54, blue: 0.18).opacity(configuration.isPressed ? 0.08 : 0.25), radius: 10, y: 5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct ResultsSecondaryButtonStyle: ButtonStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.16, green: 0.17, blue: 0.18).opacity(0.94),
                                Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.98)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .strokeBorder(tint.opacity(0.44), lineWidth: 1.2)
            }
            .brightness(configuration.isPressed ? -0.05 : 0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct ResultsPanel: View {
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.16, green: 0.17, blue: 0.18).opacity(0.88),
                            Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.96),
                            Color(red: 0.12, green: 0.08, blue: 0.05).opacity(0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: cornerRadius - 2, style: .continuous)
                .strokeBorder(Color.white.opacity(0.05), lineWidth: 4)
                .padding(5)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [.white.opacity(0.16), Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.24), .black.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.24), radius: 10, y: 6)
    }
}

private struct ResultsBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.05, green: 0.06, blue: 0.10), Color(red: 0.15, green: 0.07, blue: 0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { column in
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(.white.opacity((row + column).isMultiple(of: 3) ? 0.028 : 0.014), lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color(red: 0.24, green: 0.15, blue: 0.09).opacity((row + column).isMultiple(of: 4) ? 0.10 : 0.04))
                                )
                                .frame(height: 86)
                        }
                    }
                }
            }
            .opacity(0.58)
            .ignoresSafeArea()
        }
    }
}

private struct ResultsCoinIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, Color(red: 1.0, green: 0.78, blue: 0.23), Color(red: 0.62, green: 0.32, blue: 0.08)],
                        center: .topLeading,
                        startRadius: 2,
                        endRadius: 28
                    )
                )

            Circle()
                .stroke(Color(red: 0.48, green: 0.25, blue: 0.06), lineWidth: 3)

            Circle()
                .stroke(.white.opacity(0.55), lineWidth: 1)
                .padding(8)
        }
    }
}

private struct ResultsGemIcon: View {
    var body: some View {
        ZStack {
            DiamondShape()
                .fill(
                    LinearGradient(
                        colors: [.white, Color(red: 0.52, green: 0.94, blue: 0.86), Color(red: 0.05, green: 0.36, blue: 0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            DiamondShape()
                .stroke(Color.white.opacity(0.68), lineWidth: 1.3)

            Path { path in
                path.move(to: CGPoint(x: 0.5, y: 0.12))
                path.addLine(to: CGPoint(x: 0.5, y: 0.88))
            }
            .stroke(.white.opacity(0.38), lineWidth: 1)
        }
    }
}

private struct ResultsDepthIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.black.opacity(0.36))

            VStack(spacing: 2) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(index == 0 ? Color(red: 1.0, green: 0.74, blue: 0.30) : Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.72))
                        .frame(width: CGFloat(24 - index * 3), height: 5)
                }
            }

            Image(systemName: "arrow.down")
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.white)
                .offset(y: 1)
        }
    }
}

private struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ResultsView(
        result: RunResult(depth: 24, coins: 18, gems: 3, gemValue: 5),
        profile: .default,
        isNewBestDepth: true,
        onRetry: {},
        onOpenUpgrades: {},
        onBackToMenu: {}
    )
}
