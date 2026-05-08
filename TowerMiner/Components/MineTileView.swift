import SwiftUI

struct MineTileView: View {
    let tile: MineTile
    let isPlayerHere: Bool
    let canDig: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tileFill)

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

            if isPlayerHere {
                Circle()
                    .fill(Color(red: 0.52, green: 0.94, blue: 0.86))
                    .padding(10)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.85), lineWidth: 2)
                            .padding(10)
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: shadowColor, radius: canDig ? 8 : 3)
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
        canDig ? Color(red: 0.55, green: 0.92, blue: 0.88).opacity(0.25) : .clear
    }
}
