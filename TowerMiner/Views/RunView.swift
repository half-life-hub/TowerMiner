import SwiftUI

struct RunView: View {
    let session: GameSession
    let onBackToMenu: () -> Void
    let onFinishRun: (RunResult) -> Void

    @State private var showDustBurst = false
    @State private var showRewardFlash = false
    @State private var damageShake = 0
    @State private var previousTopVisibleRow = 0
    @State private var shaftScrollOffset: CGFloat = 0
    @State private var activeDigPosition: GridPosition?

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
            triggerDigImpact()
        }
        .onChange(of: session.rewardFeedbackID) {
            triggerRewardFlash()
        }
        .onChange(of: session.damageFeedbackID) {
            damageShake += 1
        }
        .onChange(of: session.visibleRowRange.lowerBound) { _, newTopRow in
            animateShaftScroll(to: newTopRow)
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
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                depthBadge

                VStack(spacing: 8) {
                    runMeter(
                        title: "HP",
                        value: session.player.health,
                        maxValue: session.player.maxHealth,
                        systemImage: "heart.fill",
                        tint: Color(red: 0.95, green: 0.34, blue: 0.25)
                    )

                    runMeter(
                        title: "EN",
                        value: session.player.energy,
                        maxValue: session.player.maxEnergy,
                        systemImage: "bolt.fill",
                        tint: Color(red: 0.52, green: 0.94, blue: 0.86)
                    )
                }

                Button {
                    onFinishRun(session.makeRunResult())
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 17, weight: .black))

                        Text("Cash Out")
                            .font(.caption2.weight(.black))
                            .tracking(0.4)
                    }
                    .frame(width: 76, height: 62)
                }
                .buttonStyle(RunCashOutButtonStyle())
                .accessibilityLabel("Cash Out")
            }
        }
        .padding(.leading, 18)
        .padding(.trailing, 14)
        .padding(.vertical, 14)
        .background {
            RunHUDPanel(cornerRadius: 20)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.18),
                            Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.34),
                            .black.opacity(0.32)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.30), radius: 14, y: 8)
    }

    private var depthBadge: some View {
        HStack(spacing: 8) {
            Image("icon_depth")
                .resizable()
                .scaledToFit()
                .frame(width: 38, height: 62)

            VStack(alignment: .leading, spacing: 3) {
                Text("\(session.currentDepth)")
                    .font(.title3.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.58)

                Text("DEPTH")
                    .font(.caption2.weight(.black))
                    .tracking(0.8)
                    .foregroundStyle(.white.opacity(0.58))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 7)
        .padding(.trailing, 8)
        .frame(width: 108, height: 74)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
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
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.32), lineWidth: 1)
        }
    }

    private func playfield(width: CGFloat, availableHeight: CGFloat) -> some View {
        let isLargeBoard = width >= 760
        let isLandscape = width > availableHeight
        let boardHeight = max(
            320,
            min(
                availableHeight * (isLandscape ? 0.58 : (isLargeBoard ? 0.62 : 0.48)),
                isLargeBoard ? 760 : 520
            )
        )

        return GeometryReader { geometry in
            let spacing: CGFloat = isLargeBoard ? 7 : 5
            let boardInset: CGFloat = isLargeBoard ? 16 : 12
            let fullVisibleRows = Array(session.visibleRowRange)
            let visibleRows = rowsForCurrentOrientation(
                from: fullVisibleRows,
                maxVisibleRows: isLandscape ? 8 : fullVisibleRows.count
            )
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
                                            canDig: session.canDig(at: position),
                                            isDigAnimating: activeDigPosition == position
                                        )
                                        .frame(width: tileSize, height: tileSize)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .opacity(row >= visibleRows.suffix(2).first ?? row ? 0.92 : 1)
                        }
                    }
                    .frame(width: availableWidth, height: gridHeight, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(y: shaftScrollOffset * (tileSize + spacing))
                    .animation(.easeOut(duration: 0.24), value: shaftScrollOffset)

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

    private func rowsForCurrentOrientation(from rows: [Int], maxVisibleRows: Int) -> [Int] {
        guard rows.count > maxVisibleRows,
              let firstRow = rows.first,
              let lastRow = rows.last
        else {
            return rows
        }

        let halfWindow = maxVisibleRows / 2
        let latestStart = lastRow - maxVisibleRows + 1
        let startRow = min(max(session.player.position.row - halfWindow, firstRow), latestStart)
        return Array(startRow..<(startRow + maxVisibleRows))
    }

    private func animateShaftScroll(to newTopRow: Int) {
        let delta = newTopRow - previousTopVisibleRow
        previousTopVisibleRow = newTopRow

        guard delta > 0 else {
            return
        }

        shaftScrollOffset = CGFloat(delta)
        withAnimation(.easeOut(duration: 0.26)) {
            shaftScrollOffset = 0
        }
    }

    private var resourceStrip: some View {
        HStack(spacing: 8) {
            chip(title: "Coins", value: "\(session.player.coins)", systemImage: "circle.fill", assetName: "icon_coin", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
            chip(title: "Gems", value: "\(session.player.gems)", systemImage: "diamond.fill", assetName: "icon_gem", tint: Color(red: 0.52, green: 0.94, blue: 0.86))
            chip(title: "Bomb", value: "\(session.player.bombs)", systemImage: "burst.fill", assetName: "icon_bomb", tint: .white.opacity(0.80))

            Button {
                session.useShield()
            } label: {
                    chip(
                        title: session.player.activeShieldHits > 0 ? "Active" : "Shield",
                        value: "\(session.player.shields)",
                        systemImage: "shield.fill",
                        assetName: "icon_shield",
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

    private func chip(title: String, value: String, systemImage: String, assetName: String? = nil, tint: Color) -> some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .black))
                    .tracking(0.2)
                    .foregroundStyle(.white.opacity(0.56))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text(value)
                    .font(.headline.weight(.black))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.70)
            }

            Spacer(minLength: 4)

            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                tint.opacity(0.82),
                                tint.opacity(0.30),
                                Color.black.opacity(0.38)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                if let assetName {
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .padding(1)
                        .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                } else {
                    Image(systemName: systemImage)
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                }
            }
            .frame(width: 40, height: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.16), lineWidth: 1)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        .padding(.leading, 10)
        .padding(.trailing, 7)
        .background {
            RunStatCardBackground(cornerRadius: 14)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.14),
                            tint.opacity(0.32),
                            .black.opacity(0.30)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.20), radius: 8, y: 5)
    }

    private func runMeter(title: String, value: Int, maxValue: Int, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 9) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.86), tint.opacity(0.28), Color.black.opacity(0.38)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                if title == "HP" {
                    ProceduralHeartIcon()
                        .fill(
                            LinearGradient(
                                colors: [.white, Color(red: 1.0, green: 0.18, blue: 0.12), Color(red: 0.46, green: 0.02, blue: 0.03)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 18, height: 17)
                        .shadow(color: .black.opacity(0.38), radius: 2, y: 1)
                } else if title == "EN" {
                    ProceduralBoltIcon()
                        .fill(
                            LinearGradient(
                                colors: [.white, Color(red: 0.52, green: 0.94, blue: 0.86), Color(red: 0.05, green: 0.42, blue: 0.48)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 13, height: 22)
                        .shadow(color: .black.opacity(0.38), radius: 2, y: 1)
                } else {
                    Image(systemName: systemImage)
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 30, height: 30)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(title.uppercased())
                        .font(.caption2.weight(.black))
                        .tracking(0.7)
                        .foregroundStyle(.white.opacity(0.58))

                    Spacer(minLength: 4)

                    Text("\(value)/\(maxValue)")
                        .font(.caption.weight(.black))
                        .monospacedDigit()
                        .foregroundStyle(.white.opacity(0.86))
                }

                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.black.opacity(0.38))
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [tint.opacity(0.95), tint.opacity(0.52)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(max(0, min(value, maxValue))) / CGFloat(max(maxValue, 1)))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(.white.opacity(0.10), lineWidth: 1)
                        }
                }
                .frame(height: 9)
            }
        }
        .frame(minHeight: 32)
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

    private func triggerDigImpact() {
        guard let position = session.lastDugPosition else {
            return
        }

        activeDigPosition = position
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(180))
            if activeDigPosition == position {
                activeDigPosition = nil
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

private struct RunHUDPanel: View {
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.16, green: 0.17, blue: 0.18).opacity(0.86),
                            Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.96),
                            Color(red: 0.13, green: 0.09, blue: 0.06).opacity(0.90)
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

private struct RunCashOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.70, green: 0.42, blue: 0.16),
                                Color(red: 0.24, green: 0.12, blue: 0.07),
                                Color.black.opacity(0.55)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.28),
                                Color(red: 1.0, green: 0.78, blue: 0.23).opacity(0.50),
                                .black.opacity(0.38)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
            .shadow(color: Color(red: 1.0, green: 0.54, blue: 0.18).opacity(configuration.isPressed ? 0.10 : 0.24), radius: 10, y: 5)
            .brightness(configuration.isPressed ? -0.06 : 0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct RunStatCardBackground: View {
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.16, blue: 0.17).opacity(0.88),
                            Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.96),
                            Color(red: 0.11, green: 0.08, blue: 0.06).opacity(0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: cornerRadius - 2, style: .continuous)
                .strokeBorder(Color.white.opacity(0.045), lineWidth: 3)
                .padding(4)

            Capsule()
                .fill(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.06))
                .frame(width: 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 7)
                .padding(.vertical, 10)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

private struct ProceduralHeartIcon: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        var path = Path()
        path.move(to: CGPoint(x: width * 0.50, y: height * 0.92))
        path.addCurve(
            to: CGPoint(x: width * 0.08, y: height * 0.35),
            control1: CGPoint(x: width * 0.26, y: height * 0.74),
            control2: CGPoint(x: width * 0.02, y: height * 0.58)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.48, y: height * 0.22),
            control1: CGPoint(x: width * 0.08, y: height * 0.12),
            control2: CGPoint(x: width * 0.35, y: height * 0.06)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.92, y: height * 0.35),
            control1: CGPoint(x: width * 0.64, y: height * 0.05),
            control2: CGPoint(x: width * 0.92, y: height * 0.12)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.50, y: height * 0.92),
            control1: CGPoint(x: width * 0.98, y: height * 0.58),
            control2: CGPoint(x: width * 0.74, y: height * 0.74)
        )
        path.closeSubpath()
        return path
    }
}

private struct ProceduralBoltIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX * 0.64, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.18, y: rect.midY * 1.05))
        path.addLine(to: CGPoint(x: rect.maxX * 0.47, y: rect.midY * 1.05))
        path.addLine(to: CGPoint(x: rect.maxX * 0.33, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.84, y: rect.midY * 0.72))
        path.addLine(to: CGPoint(x: rect.maxX * 0.55, y: rect.midY * 0.72))
        path.closeSubpath()
        return path
    }
}

#Preview {
    RunView(
        session: GameSession(profile: .default),
        onBackToMenu: {},
        onFinishRun: { _ in }
    )
}
