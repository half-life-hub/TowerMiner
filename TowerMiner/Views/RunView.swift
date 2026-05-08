import SwiftUI

struct RunView: View {
    let session: GameSession
    let onBackToMenu: () -> Void
    let onFinishRun: (RunResult) -> Void

    @State private var showDustBurst = false
    @State private var showRewardFlash = false
    @State private var damageShake = 0

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = min(geometry.size.width - 32, 680)
            let boardHeight = max(280, min(geometry.size.height * 0.38, 420))

            ZStack {
                LinearGradient(
                    colors: [Color.black, Color(red: 0.08, green: 0.09, blue: 0.15), Color(red: 0.05, green: 0.04, blue: 0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        header

                        mineBoard(height: boardHeight)
                            .modifier(ScreenShakeEffect(shakes: CGFloat(damageShake)))
                            .animation(.spring(response: 0.22, dampingFraction: 0.55), value: damageShake)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Controls move or dig. Tap blocks to mine.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.86))
                                .lineLimit(2)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: geometry.size.width > 520 ? 4 : 2), spacing: 10) {
                                runStat(title: "Coins", value: "\(session.player.coins)", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
                                runStat(title: "Gems", value: "\(session.player.gems)", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
                                runStat(title: "Bombs", value: "\(session.player.bombs)", tint: .white.opacity(0.75))
                                shieldButton
                            }
                        }

                        ControlPad(
                            onMoveLeft: session.moveLeft,
                            onMoveRight: session.moveRight,
                            onMoveDown: session.moveDown
                        )

                        Spacer(minLength: 0)
                    }
                    .frame(width: contentWidth)
                    .padding(.top, 18)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)

                if session.isRunOver {
                    runOverOverlay
                }
            }
        }
        .onChange(of: session.digFeedbackID) {
            triggerDust()
        }
        .onChange(of: session.rewardFeedbackID) {
            triggerRewardFlash()
        }
        .onChange(of: session.damageFeedbackID) {
            damageShake += 1
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Run")
                    .font(.title.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text("Depth \(session.currentDepth)")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                meter(title: "HP", value: session.player.health, maxValue: session.player.maxHealth, tint: Color(red: 0.95, green: 0.34, blue: 0.25))
                meter(title: "EN", value: session.player.energy, maxValue: session.player.maxEnergy, tint: Color(red: 0.52, green: 0.94, blue: 0.86))
            }
            .frame(width: 118)

            Button("Cash Out") {
                onFinishRun(session.makeRunResult())
            }
            .buttonStyle(.borderedProminent)
            .font(.headline.weight(.semibold))
        }
    }

    private func mineBoard(height: CGFloat) -> some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 6
            let boardInset: CGFloat = 12
            let availableWidth = geometry.size.width - (boardInset * 2)
            let visibleRows = Array(session.visibleRowRange)
            let availableHeight = geometry.size.height - (boardInset * 2)
            let widthTileSize = floor((availableWidth - (CGFloat(session.columns - 1) * spacing)) / CGFloat(session.columns))
            let heightTileSize = floor((availableHeight - (CGFloat(max(0, visibleRows.count - 1)) * spacing)) / CGFloat(visibleRows.count))
            let tileSize = max(18, min(widthTileSize, heightTileSize))
            let boardHeight = (CGFloat(visibleRows.count) * tileSize) + (CGFloat(max(0, visibleRows.count - 1)) * spacing)

            ZStack {
                VStack(spacing: spacing) {
                    ForEach(visibleRows, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<session.columns, id: \.self) { column in
                                let position = GridPosition(row: row, column: column)
                                let tile = session.tiles[row][column]

                                Button {
                                    session.dig(at: position)
                                } label: {
                                    MineTileView(
                                        tile: tile,
                                        isPlayerHere: session.player.position == position,
                                        canDig: session.canDig(at: position)
                                    )
                                    .frame(width: tileSize, height: tileSize)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .frame(width: availableWidth, height: boardHeight, alignment: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                if showDustBurst {
                    ParticleBurst(color: Color(red: 0.72, green: 0.54, blue: 0.36), count: 10)
                        .transition(.opacity)
                }

                if showRewardFlash {
                    ParticleBurst(color: Color(red: 0.52, green: 0.94, blue: 0.86), count: 14)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(boardInset)
        }
        .frame(height: height)
        .background(
            LinearGradient(
                colors: [.black.opacity(0.38), Color(red: 0.04, green: 0.04, blue: 0.07).opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }

    private var shieldButton: some View {
        Button {
            session.useShield()
        } label: {
            runStat(
                title: session.player.activeShieldHits > 0 ? "Shield Active" : "Shields",
                value: "\(session.player.shields)",
                tint: Color(red: 0.62, green: 0.77, blue: 1.0)
            )
        }
        .buttonStyle(.plain)
        .disabled(session.player.shields == 0 || session.player.activeShieldHits > 0 || session.isRunOver)
    }

    private var runOverOverlay: some View {
        VStack(spacing: 16) {
            Text("Run Over")
                .font(.largeTitle.weight(.black))
                .foregroundStyle(.white)
            Text("Depth \(session.currentDepth)")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white.opacity(0.78))
            Button("View Results") {
                onFinishRun(session.makeRunResult())
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(28)
        .frame(maxWidth: 300)
        .background(.black.opacity(0.84), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(red: 0.95, green: 0.34, blue: 0.25).opacity(0.7), lineWidth: 1)
        )
    }

    private func runStat(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.68))
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint)
                .frame(width: 4)
        }
    }

    private func meter(title: String, value: Int, maxValue: Int, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption.weight(.bold))
                Spacer()
                Text("\(value)/\(maxValue)")
                    .font(.caption.weight(.bold))
            }
            .foregroundStyle(.white.opacity(0.82))

            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(.white.opacity(0.12))
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(tint)
                            .frame(width: geometry.size.width * CGFloat(max(0, min(value, maxValue))) / CGFloat(max(maxValue, 1)))
                    }
            }
            .frame(height: 6)
        }
    }

    private func triggerDust() {
        withAnimation(.easeOut(duration: 0.12)) {
            showDustBurst = true
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(260))
            withAnimation(.easeOut(duration: 0.16)) {
                showDustBurst = false
            }
        }
    }

    private func triggerRewardFlash() {
        withAnimation(.spring(response: 0.22, dampingFraction: 0.6)) {
            showRewardFlash = true
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(420))
            withAnimation(.easeOut(duration: 0.18)) {
                showRewardFlash = false
            }
        }
    }
}

private struct ParticleBurst: View {
    let color: Color
    let count: Int

    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(color.opacity(0.8))
                    .frame(width: CGFloat(4 + (index % 3) * 2), height: CGFloat(4 + (index % 3) * 2))
                    .offset(
                        x: cos(Double(index) * 1.7) * CGFloat(18 + index * 3),
                        y: sin(Double(index) * 1.7) * CGFloat(18 + index * 3)
                    )
            }
        }
        .frame(width: 10, height: 10)
    }
}

private struct ScreenShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakes: CGFloat

    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: sin(shakes * .pi * 3) * amount, y: 0))
    }
}

#Preview {
    RunView(
        session: GameSession(profile: .default),
        onBackToMenu: {},
        onFinishRun: { _ in }
    )
}
