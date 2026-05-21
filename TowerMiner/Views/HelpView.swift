import SwiftUI

struct HelpView: View {
    let onClose: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = min(geometry.size.width - 32, 680)

            ZStack {
                HelpScreenBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        header
                        HelpCard(
                            title: "Move Through The Mine",
                            subtitle: "Use the control buttons to move left, right, or dig deeper."
                        ) {
                            HStack(spacing: 12) {
                                HelpAssetIcon(name: "button_left")
                                HelpAssetIcon(name: "button_down")
                                HelpAssetIcon(name: "button_right")
                            }
                        }

                        HelpCard(
                            title: "Dig Blocks",
                            subtitle: "Move into a block to mine it. Dirt breaks fast, stone takes more hits, and hard stone costs more effort."
                        ) {
                            HelpIconStrip(assetNames: ["tile_dirt", "tile_stone", "tile_hard_stone"])
                        }

                        HelpCard(
                            title: "Collect Treasure",
                            subtitle: "Gold, gems, and chests increase your run payout. Push deeper to find better rewards."
                        ) {
                            HelpIconStrip(assetNames: ["tile_gold", "tile_gem", "tile_chest"])
                        }

                        HelpCard(
                            title: "Avoid Hazards",
                            subtitle: "Lava and spikes damage the miner. Shields can absorb one bad hit when you have them."
                        ) {
                            HelpIconStrip(assetNames: ["tile_lava", "tile_spike", "player_miner"])
                        }

                        HelpCard(
                            title: "Use Tools",
                            subtitle: "Tap Bomb to arm it, then tap an adjacent target to blast nearby blocks. Tap Shield to guard against the next hazard hit."
                        ) {
                            HStack(spacing: 12) {
                                HelpFramedIcon {
                                    ProceduralBombIcon()
                                        .frame(width: 30, height: 30)
                                }
                                HelpSymbolIcon(symbol: "hand.tap.fill", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
                                HelpFramedIcon {
                                    ProceduralShieldIcon()
                                        .frame(width: 29, height: 32)
                                }
                            }
                        }

                        HelpCard(
                            title: "Upgrade Between Runs",
                            subtitle: "Bank your haul, return to the menu, and spend credits on stronger upgrades before the next descent."
                        ) {
                            HStack(spacing: 12) {
                                HelpSymbolIcon(symbol: "creditcard.fill", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
                                HelpSymbolIcon(symbol: "wrench.and.screwdriver.fill", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
                                HelpSymbolIcon(symbol: "heart.fill", tint: Color(red: 1.0, green: 0.32, blue: 0.28))
                            }
                        }
                    }
                    .frame(width: contentWidth)
                    .padding(.vertical, 28)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .black))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                }
                .buttonStyle(HelpCloseButtonStyle())
                .padding(.top, 14)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .accessibilityLabel("Close help")
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.30), radius: 14)
                .accessibilityLabel("Tower Miner")

            Text("How To Play")
                .font(.title.bold())
                .foregroundStyle(.white)

            Text("Mine downward, grab rewards, survive hazards, then upgrade for the next run.")
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
}

private struct HelpCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            content
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 6) {
                Text(title.uppercased())
                    .font(.caption.weight(.black))
                    .tracking(0.9)
                    .foregroundStyle(Color(red: 0.52, green: 0.94, blue: 0.86))

                Text(subtitle)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.leading, 28)
        .padding(.trailing, 20)
        .padding(.vertical, 16)
        .background {
            ZStack {
                Image("panel_hud")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.62)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.16, green: 0.17, blue: 0.18).opacity(0.82),
                                Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.92)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.22),
                            Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.42),
                            .black.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.28), radius: 12, y: 8)
    }
}

private struct HelpIconStrip: View {
    let assetNames: [String]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(assetNames, id: \.self) { assetName in
                HelpAssetIcon(name: assetName)
            }
        }
    }
}

private struct HelpAssetIcon: View {
    let name: String

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .padding(5)
            .frame(width: 68, height: 68)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.black.opacity(0.32))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.18), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.24), radius: 7, y: 4)
    }
}

private struct HelpSymbolIcon: View {
    let symbol: String
    let tint: Color

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 30, weight: .black))
            .foregroundStyle(.white)
            .frame(width: 68, height: 68)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.82), tint.opacity(0.28), Color.black.opacity(0.45)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.20), lineWidth: 1)
            }
    }
}

private struct HelpFramedIcon<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(width: 68, height: 68)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
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
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.20), lineWidth: 1)
            }
    }
}

private struct HelpScreenBackground: View {
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
                                .stroke(.white.opacity((row + column).isMultiple(of: 3) ? 0.022 : 0.014), lineWidth: 1)
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

private struct HelpCloseButtonStyle: ButtonStyle {
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

#Preview {
    HelpView(onClose: {})
}
