import SwiftUI

struct RunView: View {
    let session: GameSession
    let onBackToMenu: () -> Void
    let onFinishRun: (RunResult) -> Void

    @State private var damageShake = 0
    @State private var previousTopVisibleRow = 0
    @State private var shaftScrollOffset: CGFloat = 0
    @State private var activeDigPosition: GridPosition?
    @State private var activeBlastPositions: Set<GridPosition> = []
    @State private var isPlacingBomb = false

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
                        onMoveLeft: {
                            performGameAction {
                                session.moveLeft()
                            }
                        },
                        onMoveRight: {
                            performGameAction {
                                session.moveRight()
                            }
                        },
                        onMoveDown: {
                            performGameAction {
                                session.moveDown()
                            }
                        }
                    )
                    .frame(width: contentWidth)

                    Text(appVersionLabel)
                        .font(.caption2.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(.white.opacity(0.42))
                        .frame(width: contentWidth)
                        .accessibilityLabel("App version \(appVersionLabel)")
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
            triggerDigImpact()
        }
        .onChange(of: session.bombFeedbackID) {
            triggerBombImpact()
        }
        .onChange(of: session.damageFeedbackID) {
            damageShake += 1
        }
        .onChange(of: session.visibleRowRange.lowerBound) { _, newTopRow in
            animateShaftScroll(to: newTopRow)
        }
    }

    private var appVersionLabel: String {
        let info = Bundle.main.infoDictionary
        let name = info?["CFBundleDisplayName"] as? String
            ?? info?["CFBundleName"] as? String
            ?? "TowerMiner"
        let version = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"

        return "\(name) \(version)(\(build))"
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
            ProceduralDepthGaugeIcon()
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
                        Text(isPlacingBomb ? "Tap adjacent target" : "Tap adjacent blocks")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(isPlacingBomb ? Color(red: 1.0, green: 0.74, blue: 0.30).opacity(0.90) : .white.opacity(0.46))
                    }

                    VStack(spacing: spacing) {
                        ForEach(visibleRows, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0..<session.columns, id: \.self) { column in
                                    let position = GridPosition(row: row, column: column)
                                    let tile = session.tiles[row][column]

                                    Button {
                                        handleTileTap(at: position)
                                    } label: {
                                        MineTileView(
                                            tile: tile,
                                            isPlayerHere: session.player.position == position,
                                            canDig: session.canDig(at: position) || session.canPlaceBomb(at: position),
                                            isDigAnimating: activeDigPosition == position || activeBlastPositions.contains(position)
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

            }
        }
        .frame(height: boardHeight)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.13, green: 0.15, blue: 0.17).opacity(0.96),
                    Color(red: 0.05, green: 0.06, blue: 0.08).opacity(0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
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

        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            shaftScrollOffset = CGFloat(delta)
        }

        Task { @MainActor in
            await Task.yield()
            withAnimation(.smooth(duration: 0.32)) {
                shaftScrollOffset = 0
            }
        }
    }

    private var resourceStrip: some View {
        HStack(spacing: 8) {
            chip(title: "Coins", value: "\(session.player.coins)", systemImage: "circle.fill", tint: Color(red: 1.0, green: 0.78, blue: 0.23))
            chip(title: "Gems", value: "\(session.player.gems)", systemImage: "diamond.fill", tint: Color(red: 0.52, green: 0.94, blue: 0.86))

            Button {
                isPlacingBomb.toggle()
            } label: {
                chip(title: "Bomb", value: "\(session.player.bombs)", systemImage: "burst.fill", tint: isPlacingBomb ? Color(red: 1.0, green: 0.74, blue: 0.30) : .white.opacity(0.80))
            }
            .buttonStyle(.plain)
            .disabled(session.player.bombs == 0 || session.isRunOver)
            .opacity(session.player.bombs == 0 || session.isRunOver ? 0.48 : 1)

            Button {
                session.useShield()
            } label: {
                    chip(
                        title: session.player.activeShieldHits > 0 ? "Active" : "Shield",
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

                proceduralStatIcon(for: title, fallbackSystemImage: systemImage)
                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
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

    @ViewBuilder
    private func proceduralStatIcon(for title: String, fallbackSystemImage: String) -> some View {
        switch title {
        case "Coins":
            ProceduralCoinIcon()
                .frame(width: 25, height: 25)
        case "Gems":
            ProceduralGemIcon()
                .frame(width: 25, height: 25)
        case "Bomb":
            ProceduralBombIcon()
                .frame(width: 25, height: 25)
        case "Shield", "Active":
            ProceduralShieldIcon()
                .frame(width: 24, height: 27)
        default:
            Image(systemName: fallbackSystemImage)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(.white)
        }
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

    private func handleTileTap(at position: GridPosition) {
        if isPlacingBomb {
            performGameAction {
                if session.useBomb(at: position) {
                    isPlacingBomb = false
                }
            }
            return
        }

        performGameAction {
            session.dig(at: position)
        }
    }

    private func performGameAction(_ action: () -> Void) {
        withAnimation(.smooth(duration: 0.22)) {
            action()
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

    private func triggerBombImpact() {
        let positions = session.lastBombedPositions
        guard !positions.isEmpty else {
            return
        }
        let blastPositionSet = Set(positions)

        activeDigPosition = nil
        activeBlastPositions = blastPositionSet

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(260))
            if activeBlastPositions == blastPositionSet {
                activeBlastPositions = []
            }
        }
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

private struct ProceduralDepthGaugeIcon: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let shaftWidth = width * 0.34

            ZStack {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.75),
                                Color(red: 0.08, green: 0.16, blue: 0.18),
                                Color.black.opacity(0.86)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: shaftWidth, height: height * 0.88)

                Capsule()
                    .strokeBorder(Color.white.opacity(0.55), lineWidth: 1.3)
                    .frame(width: shaftWidth, height: height * 0.88)

                VStack(spacing: height * 0.055) {
                    ForEach(0..<6, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 1, style: .continuous)
                            .fill(index.isMultiple(of: 2) ? Color.white.opacity(0.82) : Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.72))
                            .frame(width: index.isMultiple(of: 2) ? width * 0.22 : width * 0.14, height: 1.4)
                    }
                }

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.95),
                                Color(red: 0.05, green: 0.42, blue: 0.48).opacity(0.86)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: shaftWidth * 0.42, height: height * 0.72)
                    .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.58), radius: 5)

                Circle()
                    .fill(Color(red: 1.0, green: 0.78, blue: 0.23))
                    .frame(width: width * 0.18, height: width * 0.18)
                    .offset(y: -height * 0.32)

                Circle()
                    .fill(Color(red: 1.0, green: 0.46, blue: 0.18))
                    .frame(width: width * 0.14, height: width * 0.14)
                    .offset(y: height * 0.34)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct ProceduralCoinIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 1.0, green: 0.78, blue: 0.23), Color(red: 0.62, green: 0.34, blue: 0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .strokeBorder(Color(red: 0.45, green: 0.24, blue: 0.03).opacity(0.55), lineWidth: 2)
                .padding(3)

            Capsule()
                .fill(Color.white.opacity(0.48))
                .frame(width: 10, height: 3)
                .rotationEffect(.degrees(-22))
                .offset(x: -4, y: -5)
        }
    }
}

private struct ProceduralGemIcon: View {
    var body: some View {
        ZStack {
            ProceduralGemShape()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 0.52, green: 0.94, blue: 0.86), Color(red: 0.03, green: 0.44, blue: 0.54)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            ProceduralGemShape()
                .stroke(Color.white.opacity(0.52), lineWidth: 1)

            ProceduralGemFacetLines()
                .stroke(Color.white.opacity(0.55), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))

            ProceduralGemFacetLines()
                .stroke(Color(red: 0.03, green: 0.44, blue: 0.54).opacity(0.38), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .blendMode(.multiply)

            Capsule()
                .fill(Color.white.opacity(0.48))
                .frame(width: 9, height: 3)
                .rotationEffect(.degrees(-25))
                .offset(x: -4, y: -6)
        }
        .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.45), radius: 5)
    }
}

private struct ProceduralGemShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.34))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height * 0.34))
        path.closeSubpath()
        return path
    }
}

private struct ProceduralGemFacetLines: Shape {
    func path(in rect: CGRect) -> Path {
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: rect.height * 0.34)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: rect.height * 0.34)
        let center = CGPoint(x: rect.midX, y: rect.height * 0.42)

        var path = Path()
        path.move(to: top)
        path.addLine(to: center)
        path.addLine(to: bottom)

        path.move(to: left)
        path.addLine(to: center)
        path.addLine(to: right)

        path.move(to: CGPoint(x: rect.width * 0.24, y: rect.height * 0.34))
        path.addLine(to: CGPoint(x: rect.width * 0.40, y: rect.height * 0.12))

        path.move(to: CGPoint(x: rect.width * 0.76, y: rect.height * 0.34))
        path.addLine(to: CGPoint(x: rect.width * 0.60, y: rect.height * 0.12))

        path.move(to: CGPoint(x: rect.width * 0.30, y: rect.height * 0.66))
        path.addLine(to: left)

        path.move(to: CGPoint(x: rect.width * 0.70, y: rect.height * 0.66))
        path.addLine(to: right)
        return path
    }
}

private struct ProceduralBombIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.34), Color(red: 0.12, green: 0.12, blue: 0.13), Color.black],
                        center: .topLeading,
                        startRadius: 1,
                        endRadius: 18
                    )
                )
                .frame(width: 22, height: 22)
                .offset(y: 2)

            Capsule()
                .fill(Color(red: 0.20, green: 0.18, blue: 0.16))
                .frame(width: 5, height: 9)
                .rotationEffect(.degrees(-34))
                .offset(x: 7, y: -9)

            Circle()
                .fill(Color(red: 1.0, green: 0.48, blue: 0.14))
                .frame(width: 6, height: 6)
                .shadow(color: Color(red: 1.0, green: 0.48, blue: 0.14), radius: 5)
                .offset(x: 11, y: -12)

            ProceduralSparkleIcon()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 1.0, green: 0.78, blue: 0.23), Color(red: 1.0, green: 0.24, blue: 0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 9, height: 9)
                .shadow(color: Color(red: 1.0, green: 0.48, blue: 0.14).opacity(0.85), radius: 6)
                .offset(x: 13, y: -14)
        }
    }
}

private struct ProceduralShieldIcon: View {
    var body: some View {
        ZStack {
            ProceduralShieldShape()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 0.62, green: 0.77, blue: 1.0), Color(red: 0.09, green: 0.20, blue: 0.38)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    ProceduralShieldShape()
                        .stroke(Color.white.opacity(0.42), lineWidth: 1.2)
                }

            ProceduralSparkleIcon()
                .fill(Color.white.opacity(0.86))
                .frame(width: 7, height: 7)
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.7), radius: 4)
                .offset(x: -5, y: -6)
        }
    }
}

private struct ProceduralShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.96, y: rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.maxX * 0.88, y: rect.height * 0.65))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX * 0.76, y: rect.height * 0.88)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.12, y: rect.height * 0.65),
            control: CGPoint(x: rect.maxX * 0.24, y: rect.height * 0.88)
        )
        path.addLine(to: CGPoint(x: rect.maxX * 0.04, y: rect.height * 0.18))
        path.closeSubpath()
        return path
    }
}

private struct ProceduralSparkleIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.62, y: rect.height * 0.38))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.62, y: rect.height * 0.62))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.38, y: rect.height * 0.62))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.38, y: rect.height * 0.38))
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
