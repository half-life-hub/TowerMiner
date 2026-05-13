import SwiftUI

struct MineTileView: View {
    let tile: MineTile
    let isPlayerHere: Bool
    let canDig: Bool
    let isDigAnimating: Bool

    var body: some View {
        ZStack {
            tileBase

            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(borderColor, lineWidth: canDig ? 2 : 1)

            if tile.type == .stone {
                Image(systemName: "circle.hexagongrid.fill")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.28))
            }
            
            if tile.type == .hardStone {
                Image(systemName: "mountain.2.fill")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.32))
            }

            if tile.type == .gold {
                Image(systemName: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(Color(red: 1.0, green: 0.78, blue: 0.23))
            }

            if tile.type == .gem {
                Image(systemName: "diamond.fill")
                    .font(.caption)
                    .foregroundStyle(Color(red: 0.52, green: 0.94, blue: 0.86))
            }

            if tile.type == .chest {
                Image(systemName: "shippingbox.fill")
                    .font(.caption)
                    .foregroundStyle(Color(red: 0.94, green: 0.65, blue: 0.28))
            }
            
            if tile.type == .lava {
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(Color(red: 1.0, green: 0.67, blue: 0.28))
            }
            
            if tile.type == .spike {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(Color(red: 0.95, green: 0.34, blue: 0.25))
            }

            if isDigAnimating {
                DigImpactOverlay()
                    .transition(.scale(scale: 0.72).combined(with: .opacity))
            }

            if isPlayerHere {
                Image("player_miner")
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.85), radius: 8)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: shadowColor, radius: canDig ? 8 : 3)
        .scaleEffect(isDigAnimating ? 0.94 : (canDig ? 1.04 : 1.0))
        .rotationEffect(.degrees(isDigAnimating ? -1.4 : 0))
        .brightness(isDigAnimating ? 0.08 : 0)
        .animation(.spring(response: 0.2, dampingFraction: 0.72), value: canDig)
        .animation(.spring(response: 0.18, dampingFraction: 0.7), value: isPlayerHere)
        .animation(.spring(response: 0.16, dampingFraction: 0.42), value: isDigAnimating)
    }

    @ViewBuilder
    private var tileBase: some View {
        if let assetName = tileAssetName {
            Image(assetName)
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        } else {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tileFill)
        }
    }

    private var tileAssetName: String? {
        switch tile.type {
        case .empty:
            return "tile_empty"
        case .dirt:
            return "tile_dirt"
        case .stone:
            return "tile_stone"
        case .hardStone:
            return "tile_hard_stone"
        case .gold:
            return "tile_gold"
        case .gem:
            return "tile_gem"
        case .chest:
            return "tile_chest"
        case .lava:
            return "tile_lava"
        case .spike:
            return "tile_spike"
        }
    }

    private var tileFill: some ShapeStyle {
        switch tile.type {
        case .empty:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.black.opacity(0.15), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        case .dirt:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.42, green: 0.27, blue: 0.18), Color(red: 0.29, green: 0.18, blue: 0.12)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .stone:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.38, green: 0.44, blue: 0.54), Color(red: 0.24, green: 0.29, blue: 0.36)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .gold:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.58, green: 0.38, blue: 0.12), Color(red: 0.34, green: 0.22, blue: 0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .gem:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.12, green: 0.48, blue: 0.52), Color(red: 0.06, green: 0.22, blue: 0.28)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .chest:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.47, green: 0.28, blue: 0.14), Color(red: 0.23, green: 0.13, blue: 0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .hardStone:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.24, green: 0.29, blue: 0.36), Color(red: 0.13, green: 0.16, blue: 0.21)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .lava:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.95, green: 0.23, blue: 0.08), Color(red: 0.40, green: 0.05, blue: 0.02)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        case .spike:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(red: 0.33, green: 0.35, blue: 0.39), Color(red: 0.13, green: 0.14, blue: 0.17)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }

    private var borderColor: Color {
        if isPlayerHere {
            return .white.opacity(0.9)
        }

        if canDig {
            return Color(red: 0.55, green: 0.92, blue: 0.88)
        }

        return .white.opacity(tile.isEmpty ? 0.06 : 0.12)
    }

    private var shadowColor: Color {
        if tile.type == .gem {
            return Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.45)
        }

        if tile.type == .lava {
            return Color(red: 1.0, green: 0.22, blue: 0.08).opacity(0.5)
        }

        return canDig ? Color(red: 0.55, green: 0.92, blue: 0.88).opacity(0.25) : .clear
    }
}

private struct DigImpactOverlay: View {
    var body: some View {
        ZStack {
            ForEach(0..<7, id: \.self) { index in
                Capsule()
                    .fill(Color(red: 0.95, green: 0.76, blue: 0.45).opacity(0.88))
                    .frame(width: 3, height: CGFloat(10 + (index % 3) * 4))
                    .offset(y: -20)
                    .rotationEffect(.degrees(Double(index) * 51))
            }

            Image(systemName: "hammer.fill")
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(.white.opacity(0.90))
                .shadow(color: .black.opacity(0.55), radius: 2, y: 1)
                .rotationEffect(.degrees(-28))
                .offset(x: 8, y: -8)

            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(red: 0.95, green: 0.76, blue: 0.45).opacity(0.72), lineWidth: 2)
                .padding(3)
        }
        .allowsHitTesting(false)
    }
}
