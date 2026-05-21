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
                .strokeBorder(borderColor, lineWidth: isPlayerHere ? 2 : 1)

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
                DigImpactOverlay(tile: tile)
                    .transition(.scale(scale: 0.72).combined(with: .opacity))
            }

            if isPlayerHere {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.70))
                        .padding(5)

                    Circle()
                        .strokeBorder(Color.white.opacity(0.95), lineWidth: 2)
                        .padding(4)

                    Circle()
                        .strokeBorder(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.95), lineWidth: 3)
                        .padding(8)

                    Image("player_miner")
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                }
                .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.95), radius: 9)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: shadowColor, radius: isPlayerHere ? 8 : 3)
        .scaleEffect(isDigAnimating ? 0.94 : (isPlayerHere ? 1.04 : 1.0))
        .rotationEffect(.degrees(isDigAnimating ? -1.4 : 0))
        .brightness(isDigAnimating ? 0.08 : 0)
        .animation(.smooth(duration: 0.20), value: isPlayerHere)
        .animation(.smooth(duration: 0.16), value: isDigAnimating)
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
            return Color(red: 0.55, green: 0.92, blue: 0.88).opacity(0.95)
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

        return isPlayerHere ? Color(red: 0.55, green: 0.92, blue: 0.88).opacity(0.38) : .clear
    }
}

private struct DigImpactOverlay: View {
    let tile: MineTile

    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                let offset = chipOffset(index)

                RockChipShape(variant: index)
                    .fill(chipColor(index))
                    .frame(width: chipWidth(index), height: chipHeight(index))
                    .rotationEffect(.degrees(chipRotation(index)))
                    .offset(x: offset.width, y: offset.height)
                    .shadow(color: .black.opacity(0.38), radius: 1, y: 1)
            }

            ForEach(0..<5, id: \.self) { index in
                let offset = dustOffset(index)

                Circle()
                    .fill(chipColor(index).opacity(0.26))
                    .frame(width: CGFloat(8 + index), height: CGFloat(6 + index))
                    .blur(radius: 0.4)
                    .offset(x: offset.width, y: offset.height)
            }

            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(chipColor(0).opacity(0.52), lineWidth: 2)
                .padding(4)
        }
        .allowsHitTesting(false)
    }

    private var chipPalette: [Color] {
        switch tile.type {
        case .empty:
            return [
                Color(red: 0.22, green: 0.22, blue: 0.24),
                Color(red: 0.12, green: 0.13, blue: 0.15),
                Color(red: 0.43, green: 0.39, blue: 0.34)
            ]
        case .dirt, .chest:
            return [
                Color(red: 0.65, green: 0.43, blue: 0.23),
                Color(red: 0.39, green: 0.25, blue: 0.15),
                Color(red: 0.84, green: 0.64, blue: 0.36)
            ]
        case .stone, .hardStone, .spike:
            return [
                Color(red: 0.56, green: 0.60, blue: 0.66),
                Color(red: 0.29, green: 0.33, blue: 0.39),
                Color(red: 0.72, green: 0.74, blue: 0.76)
            ]
        case .gold:
            return [
                Color(red: 0.96, green: 0.72, blue: 0.22),
                Color(red: 0.48, green: 0.32, blue: 0.13),
                Color(red: 0.73, green: 0.66, blue: 0.54)
            ]
        case .gem:
            return [
                Color(red: 0.52, green: 0.94, blue: 0.86),
                Color(red: 0.12, green: 0.48, blue: 0.52),
                Color(red: 0.72, green: 0.96, blue: 0.94)
            ]
        case .lava:
            return [
                Color(red: 1.0, green: 0.35, blue: 0.10),
                Color(red: 0.46, green: 0.08, blue: 0.04),
                Color(red: 1.0, green: 0.76, blue: 0.24)
            ]
        }
    }

    private func chipColor(_ index: Int) -> Color {
        chipPalette[index % chipPalette.count]
    }

    private func chipWidth(_ index: Int) -> CGFloat {
        CGFloat([10, 7, 12, 8, 9, 6, 11, 7, 10, 8, 6, 9][index % 12])
    }

    private func chipHeight(_ index: Int) -> CGFloat {
        CGFloat([8, 6, 9, 7, 6, 5, 8, 5, 7, 6, 5, 7][index % 12])
    }

    private func chipRotation(_ index: Int) -> Double {
        Double([-18, 24, -42, 58, 13, -68, 36, -8, 73, -28, 44, -54][index % 12])
    }

    private func chipOffset(_ index: Int) -> CGSize {
        let offsets = [
            CGSize(width: -14, height: -9),
            CGSize(width: -7, height: -16),
            CGSize(width: 7, height: -15),
            CGSize(width: 15, height: -8),
            CGSize(width: -18, height: 2),
            CGSize(width: 18, height: 3),
            CGSize(width: -10, height: 13),
            CGSize(width: 2, height: 16),
            CGSize(width: 13, height: 12),
            CGSize(width: -2, height: -4),
            CGSize(width: 8, height: 3),
            CGSize(width: -9, height: 6)
        ]

        return offsets[index % offsets.count]
    }

    private func dustOffset(_ index: Int) -> CGSize {
        let offsets = [
            CGSize(width: -16, height: -2),
            CGSize(width: -7, height: 9),
            CGSize(width: 5, height: -10),
            CGSize(width: 14, height: 5),
            CGSize(width: 0, height: 14)
        ]

        return offsets[index % offsets.count]
    }
}

private struct RockChipShape: Shape {
    let variant: Int

    func path(in rect: CGRect) -> Path {
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let midX = rect.midX
        let midY = rect.midY

        var path = Path()

        switch variant % 4 {
        case 0:
            path.move(to: CGPoint(x: midX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: midY * 0.92))
            path.addLine(to: CGPoint(x: maxX * 0.72, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: maxY * 0.82))
            path.addLine(to: CGPoint(x: minX * 0.82, y: minY + rect.height * 0.28))
        case 1:
            path.move(to: CGPoint(x: minX + rect.width * 0.18, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: minY + rect.height * 0.22))
            path.addLine(to: CGPoint(x: maxX * 0.86, y: maxY))
            path.addLine(to: CGPoint(x: midX * 0.74, y: maxY * 0.88))
            path.addLine(to: CGPoint(x: minX, y: midY))
        case 2:
            path.move(to: CGPoint(x: minX, y: midY * 0.72))
            path.addLine(to: CGPoint(x: midX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: minY + rect.height * 0.38))
            path.addLine(to: CGPoint(x: maxX * 0.78, y: maxY))
            path.addLine(to: CGPoint(x: minX + rect.width * 0.16, y: maxY * 0.86))
        default:
            path.move(to: CGPoint(x: minX + rect.width * 0.24, y: minY))
            path.addLine(to: CGPoint(x: maxX * 0.82, y: minY + rect.height * 0.12))
            path.addLine(to: CGPoint(x: maxX, y: maxY * 0.64))
            path.addLine(to: CGPoint(x: midX * 0.90, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: maxY * 0.68))
            path.addLine(to: CGPoint(x: minX + rect.width * 0.08, y: midY * 0.72))
        }

        path.closeSubpath()
        return path
    }
}
