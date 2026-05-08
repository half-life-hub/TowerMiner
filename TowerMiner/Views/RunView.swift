import SwiftUI

struct RunView: View {
    let session: GameSession
    let onBackToMenu: () -> Void
    let onFinishRun: (RunResult) -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.10, green: 0.11, blue: 0.18)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mine Run")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.white)
                        Text("Depth \(session.currentDepth)")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.72))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("HP \(session.player.health)/\(session.player.maxHealth)")
                            .foregroundStyle(.white)
                        Text("EN \(session.player.energy)/\(session.player.maxEnergy)")
                            .foregroundStyle(.white.opacity(0.72))
                    }
                    Spacer()
                    Button("Cash Out") {
                        onFinishRun(session.makeRunResult())
                    }
                        .buttonStyle(.borderedProminent)
                }

                GeometryReader { geometry in
                    let spacing: CGFloat = 6
                    let horizontalInset: CGFloat = 24
                    let availableWidth = geometry.size.width - horizontalInset
                    let tileSize = floor((availableWidth - (CGFloat(session.columns - 1) * spacing)) / CGFloat(session.columns))
                    let visibleRows = Array(session.visibleRowRange)
                    let boardHeight = (CGFloat(visibleRows.count) * tileSize) + (CGFloat(max(0, visibleRows.count - 1)) * spacing)

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
                }
                .frame(height: 420)
                .padding(12)
                .background(.black.opacity(0.22), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 12) {
                    Text("Controls move or dig. Tap blocks to mine.")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    HStack(spacing: 16) {
                        runStat(title: "Coins", value: "\(session.player.coins)")
                        runStat(title: "Gems", value: "\(session.player.gems)")
                    }

                    HStack(spacing: 16) {
                        runStat(title: "Bombs", value: "\(session.player.bombs)")
                        Button {
                            session.useShield()
                        } label: {
                            runStat(
                                title: session.player.activeShieldHits > 0 ? "Shield Active" : "Shields",
                                value: "\(session.player.shields)"
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(session.player.shields == 0 || session.player.activeShieldHits > 0 || session.isRunOver)
                    }
                }

                ControlPad(
                    onMoveLeft: session.moveLeft,
                    onMoveRight: session.moveRight,
                    onMoveDown: session.moveDown
                )

                Spacer()
            }
            .padding(24)

            if session.isRunOver {
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
                .background(.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color(red: 0.95, green: 0.34, blue: 0.25).opacity(0.7), lineWidth: 1)
                )
            }
        }
    }

    private func runStat(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.68))
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    RunView(
        session: GameSession(profile: .default),
        onBackToMenu: {},
        onFinishRun: { _ in }
    )
}
