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
                        colors: [Color(red: 0.10, green: 0.10, blue: 0.13), Color(red: 0.22, green: 0.13, blue: 0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(spacing: 12) {
                ZStack {
                    ForEach(0..<4, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(red: 0.30, green: 0.20, blue: 0.14).opacity(0.92))
                            .frame(width: 56, height: 38)
                            .offset(x: CGFloat(index - 2) * 32, y: CGFloat(index % 2) * 18)
                    }

                    Diamond()
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color(red: 0.52, green: 0.94, blue: 0.86), Color(red: 0.10, green: 0.52, blue: 0.56)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)
                        .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.85), radius: 20)
                }
                .frame(height: 118)

                HStack(spacing: 10) {
                    Label("Best \(profile.bestDepth)", systemImage: "arrow.down.to.line.compact")
                    Label("\(profile.totalCredits) credits", systemImage: "creditcard.fill")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.78))
            }
            .padding(20)
        }
        .frame(height: 210)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }

    private var progressPanel: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatTile(title: "Credits", value: "\(profile.totalCredits)", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
                StatTile(title: "Best Depth", value: "\(profile.bestDepth)", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
            }

            HStack(spacing: 12) {
                StatTile(title: "Rig Level", value: "\(totalUpgradeLevels)", tint: Color(red: 0.62, green: 0.77, blue: 1.0))
                StatTile(title: "Gem Value", value: "\(5 + profile.gemValueLevel * 2)", tint: Color(red: 0.85, green: 0.60, blue: 1.0))
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

private struct StatTile: View {
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.62))
            Text(value)
                .font(.title2.weight(.black))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.70)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.black.opacity(0.30), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(tint)
                .frame(width: 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
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
            .foregroundStyle(.black)
            .padding(.vertical, 17)
            .background(
                LinearGradient(
                    colors: [Color.white, Color(red: 0.52, green: 0.94, blue: 0.86)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.30), radius: 14, y: 8)
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
            .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
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
