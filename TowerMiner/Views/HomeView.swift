import SwiftUI

struct HomeView: View {
    let profile: PlayerProfile
    let onStartRun: () -> Void
    let onOpenUpgrades: () -> Void

    private var totalUpgradeLevels: Int {
        UpgradeID.allCases.reduce(0) { total, upgrade in
            total + profile.level(for: upgrade)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = min(geometry.size.width - 32, 620)

            ZStack {
                MineMenuBackground()

                ScrollView {
                    VStack(spacing: 22) {
                        titleBlock
                        mineEmblem
                        progressPanel
                        actionPanel
                    }
                    .frame(width: contentWidth)
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private var titleBlock: some View {
        VStack(spacing: 8) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 360)
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.32), radius: 14)
                .accessibilityLabel("Tower Miner")

            Text("Dig deep. Bank the haul. Upgrade the rig.")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.70))
                .multilineTextAlignment(.center)
        }
    }

    private var mineEmblem: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.18, green: 0.19, blue: 0.20),
                            Color(red: 0.06, green: 0.07, blue: 0.09),
                            Color(red: 0.22, green: 0.13, blue: 0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.16), radius: 22, y: 10)

            VStack(spacing: 0) {
                Image("menu_emblem")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.28), radius: 16, y: 6)
                    .accessibilityHidden(true)

                HStack(spacing: 10) {
                    Label("Best \(profile.bestDepth)", systemImage: "arrow.down.to.line.compact")
                    Label("\(profile.totalCredits) credits", systemImage: "creditcard.fill")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.78))
            }
            .padding(20)
        }
        .frame(height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.28),
                            Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.62),
                            Color(red: 0.52, green: 0.35, blue: 0.20).opacity(0.50)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .overlay(alignment: .top) {
            Capsule()
                .fill(.white.opacity(0.12))
                .frame(height: 2)
                .padding(.horizontal, 34)
                .padding(.top, 10)
        }
        .overlay(alignment: .bottom) {
            Capsule()
                .fill(.black.opacity(0.42))
                .frame(height: 3)
                .padding(.horizontal, 36)
                .padding(.bottom, 9)
        }
        .overlay(alignment: .topLeading) {
            emblemCornerGem
                .padding(14)
        }
        .overlay(alignment: .topTrailing) {
            emblemCornerGem
                .padding(14)
        }
    }

    private var emblemCornerGem: some View {
        Diamond()
            .fill(
                LinearGradient(
                    colors: [
                        .white.opacity(0.86),
                        Color(red: 0.52, green: 0.94, blue: 0.86),
                        Color(red: 0.05, green: 0.42, blue: 0.48)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 14, height: 14)
            .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.62), radius: 9)
    }

    private var progressPanel: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatBar(title: "Credits", value: "\(profile.totalCredits)", symbol: "creditcard.fill", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
                StatBar(title: "Best Depth", value: "\(profile.bestDepth)", symbol: "arrow.down.to.line.compact", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
            }

            HStack(spacing: 12) {
                StatBar(title: "Rig Level", value: "\(totalUpgradeLevels)", symbol: "wrench.and.screwdriver.fill", tint: Color(red: 0.62, green: 0.77, blue: 1.0))
                StatBar(title: "Gem Value", value: "\(5 + profile.gemValueLevel * 2)", symbol: "diamond.fill", tint: Color(red: 0.85, green: 0.60, blue: 1.0))
            }
        }
    }

    private var actionPanel: some View {
        VStack(spacing: 12) {
            Button(action: onStartRun) {
                Label("Start Run", systemImage: "arrow.down.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryGameButtonStyle())

            Button(action: onOpenUpgrades) {
                Label("Upgrade Rig", systemImage: "wrench.and.screwdriver.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryGameButtonStyle())
        }
    }
}

private struct MineMenuBackground: View {
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
                                .stroke(.white.opacity((row + column).isMultiple(of: 3) ? 0.040 : 0.025), lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color(red: 0.25, green: 0.16, blue: 0.10).opacity((row + column).isMultiple(of: 4) ? 0.12 : 0.05))
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

private struct StatBar: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                tint.opacity(0.92),
                                tint.opacity(0.40),
                                Color.black.opacity(0.45)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: symbol)
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
            }
            .frame(width: 38, height: 34)
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.22), lineWidth: 1)
            }

            Text(title.uppercased())
                .font(.caption.weight(.black))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.66))

            Spacer(minLength: 10)

            Text(value)
                .font(.title3.weight(.black))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.70)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
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
                                tint.opacity(0.72),
                                tint.opacity(0.20),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 5)
                    .padding(.horizontal, 14)
                    .padding(.top, 7)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.20),
                            tint.opacity(0.44),
                            .black.opacity(0.36)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: tint.opacity(0.10), radius: 10, y: 5)
    }
}

private struct Diamond: Shape {
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

private struct PrimaryGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.black))
            .foregroundStyle(.white)
            .padding(.vertical, 17)
            .padding(.horizontal, 18)
            .background(
                GameMenuButtonBackground(
                    isPressed: configuration.isPressed,
                    isPrimary: true
                )
            )
            .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(configuration.isPressed ? 0.18 : 0.34), radius: 18, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct SecondaryGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background(
                GameMenuButtonBackground(
                    isPressed: configuration.isPressed,
                    isPrimary: false
                )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct GameMenuButtonBackground: View {
    let isPressed: Bool
    let isPrimary: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: isPrimary
                            ? [
                                Color(red: 0.22, green: 0.24, blue: 0.24),
                                Color(red: 0.08, green: 0.09, blue: 0.11),
                                Color(red: 0.24, green: 0.15, blue: 0.08)
                            ]
                            : [
                                Color(red: 0.16, green: 0.17, blue: 0.18),
                                Color(red: 0.05, green: 0.06, blue: 0.08),
                                Color(red: 0.12, green: 0.09, blue: 0.07)
                            ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(isPrimary ? 0.42 : 0.24),
                            Color(red: 0.52, green: 0.94, blue: 0.86).opacity(isPrimary ? 0.88 : 0.52),
                            Color(red: 0.52, green: 0.35, blue: 0.20).opacity(0.55)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isPrimary ? 2 : 1.5
                )

            HStack {
                cornerGem
                Spacer()
                cornerGem
            }
            .padding(.horizontal, 12)
        }
        .overlay(alignment: .top) {
            Capsule()
                .fill(.white.opacity(isPrimary ? 0.16 : 0.08))
                .frame(height: 2)
                .padding(.horizontal, 22)
                .padding(.top, 7)
        }
        .overlay(alignment: .bottom) {
            Capsule()
                .fill(.black.opacity(0.42))
                .frame(height: 3)
                .padding(.horizontal, 24)
                .padding(.bottom, 6)
        }
        .brightness(isPressed ? -0.05 : 0)
    }

    private var cornerGem: some View {
        Diamond()
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(isPrimary ? 0.95 : 0.70),
                        Color(red: 0.52, green: 0.94, blue: 0.86),
                        Color(red: 0.05, green: 0.42, blue: 0.48)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: isPrimary ? 13 : 10, height: isPrimary ? 13 : 10)
            .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(isPrimary ? 0.78 : 0.38), radius: 8)
    }
}

#Preview {
    HomeView(
        profile: PlayerProfile(
            totalCredits: 145,
            bestDepth: 72,
            maxHealthLevel: 2,
            maxEnergyLevel: 1,
            startingBombsLevel: 1,
            startingShieldsLevel: 1,
            gemValueLevel: 2
        ),
        onStartRun: {},
        onOpenUpgrades: {}
    )
}
