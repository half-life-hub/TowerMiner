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
            let isLargeScreen = geometry.size.width >= 700
            let horizontalPadding: CGFloat = isLargeScreen ? 56 : 28
            let contentWidth = min(geometry.size.width - horizontalPadding, isLargeScreen ? 980 : 720)

            ZStack {
                runBackground

                VStack(spacing: isLargeScreen ? 14 : 12) {
                    topBar
                        .frame(width: contentWidth)

                    playfield(width: contentWidth, availableHeight: geometry.size.height)
                        .frame(width: contentWidth)
                        .modifier(ScreenShakeEffect(shakes: CGFloat(damageShake)))

                    resourceStrip
                        .frame(width: contentWidth)

                    ControlPad(
                        onMoveLeft: session.moveLeft,
                        onMoveRight: session.moveRight,
                        onMoveDown: session.moveDown
                    )
                    .frame(width: contentWidth)
                }
                .padding(.top, isLargeScreen ? 22 : 16)
                .padding(.bottom, isLargeScreen ? 22 : 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

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

    private var runBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.05, green: 0.06, blue: 0.10), Color(red: 0.10, green: 0.05, blue: 0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { column in
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(.white.opacity((row + column).isMultiple(of: 3) ? 0.035 : 0.018), lineWidth: 1)
                                .frame(height: 82)
                        }
                    }
                }
            }
            .opacity(0.45)
            .ignoresSafeArea()
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Run")
                    .font(.title.weight(.black))
                    .foregroundStyle(.white)
                Label("Depth \(session.currentDepth)", systemImage: "arrow.down.to.line.compact")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.70))
            }

            Spacer()

            VStack(spacing: 8) {
                meter(title: "HP", value: session.player.health, maxValue: session.player.maxHealth, tint: Color(red: 0.95, green: 0.34, blue: 0.25))
                meter(title: "EN", value: session.player.energy, maxValue: session.player.maxEnergy, tint: Color(red: 0.52, green: 0.94, blue: 0.86))
            }
            .frame(width: 124)

            Button {
                onFinishRun(session.makeRunResult())
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Cash Out")
                }
                .font(.caption.weight(.black))
                .foregroundStyle(.black)
                .padding(.horizontal, 12)
                .frame(height: 42)
                .background(Color(red: 0.52, green: 0.94, blue: 0.86), in: Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cash Out")
        }
        .padding(14)
        .background(.black.opacity(0.32), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
    }

    private func playfield(width: CGFloat, availableHeight: CGFloat) -> some View {
        let isLargeBoard = width >= 760
        let boardHeight = max(
            320,
            min(
                availableHeight * (isLargeBoard ? 0.62 : 0.48),
                isLargeBoard ? 760 : 520
            )
        )

        return GeometryReader { geometry in
            let spacing: CGFloat = isLargeBoard ? 7 : 5
            let boardInset: CGFloat = isLargeBoard ? 16 : 12
            let visibleRows = Array(session.visibleRowRange)
            let availableWidth = geometry.size.width - (boardInset * 2)
            let availableTileHeight = geometry.size.height - (boardInset * 2) - 32
            let widthTileSize = floor((availableWidth - (CGFloat(session.columns - 1) * spacing)) / CGFloat(session.columns))
            let heightTileSize = floor((availableTileHeight - (CGFloat(max(0, visibleRows.count - 1)) * spacing)) / CGFloat(visibleRows.count))
            let tileSize = max(18, min(widthTileSize, heightTileSize))
            let gridHeight = (CGFloat(visibleRows.count) * tileSize) + (CGFloat(max(0, visibleRows.count - 1)) * spacing)

            ZStack {
                VStack(spacing: 10) {
                    HStack {
                        Text("Mine Shaft")
                            .font(.caption.weight(.black))
                            .foregroundStyle(.white.opacity(0.56))
                        Spacer()
                        Text("Tap adjacent blocks")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.46))
                    }

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
                    .frame(width: availableWidth, height: gridHeight, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .center)

                    Spacer(minLength: 0)
                }
                .padding(boardInset)

                if showDustBurst {
                    ParticleBurst(color: Color(red: 0.72, green: 0.54, blue: 0.36), count: 10)
                        .transition(.opacity)
                }

                if showRewardFlash {
                    ParticleBurst(color: Color(red: 0.52, green: 0.94, blue: 0.86), count: 14)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .frame(height: boardHeight)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.50), Color(red: 0.04, green: 0.04, blue: 0.07).opacity(0.96)],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
    }

    private var resourceStrip: some View {
        HStack(spacing: 8) {
            chip(title: "Coins", value: "\(session.player.coins)", systemImage: "circle.fill", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
            chip(title: "Gems", value: "\(session.player.gems)", systemImage: "diamond.fill", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
            chip(title: "Bombs", value: "\(session.player.bombs)", systemImage: "burst.fill", tint: .white.opacity(0.80))

            Button {
                session.useShield()
            } label: {
                chip(
                    title: session.player.activeShieldHits > 0 ? "Shield" : "Shields",
                    value: "\(session.player.shields)",
                    systemImage: "shield.fill",
                    tint: Color(red: 0.62, green: 0.77, blue: 1.0)
                )
            }
            .buttonStyle(.plain)
            .disabled(session.player.shields == 0 || session.player.activeShieldHits > 0 || session.isRunOver)
        }
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
        .background(.black.opacity(0.86), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(red: 0.95, green: 0.34, blue: 0.25).opacity(0.7), lineWidth: 1)
        }
    }

    private func chip(title: String, value: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 7) {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.54))
                    .lineLimit(1)
                Text(value)
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
        .padding(.horizontal, 10)
        .background(.black.opacity(0.32), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
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
