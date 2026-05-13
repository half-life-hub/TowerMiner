import SwiftUI

struct ControlPad: View {
    let onMoveLeft: () -> Void
    let onMoveRight: () -> Void
    let onMoveDown: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            controlButton(title: "Left", systemImage: "arrow.left", assetName: "button_left", action: onMoveLeft)
            controlButton(title: "Down", systemImage: "arrow.down", assetName: "button_down", action: onMoveDown)
            controlButton(title: "Right", systemImage: "arrow.right", action: onMoveRight)
        }
    }

    private func controlButton(title: String, systemImage: String, assetName: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            controlButtonLabel(title: title, systemImage: systemImage, assetName: assetName)
        }
        .buttonStyle(PressScaleButtonStyle())
    }

    @ViewBuilder
    private func controlButtonLabel(title: String, systemImage: String, assetName: String?) -> some View {
        if let assetName {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 64)
                .accessibilityLabel(title)
        } else {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title2.weight(.black))
                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 64)
            .background(
                LinearGradient(
                    colors: [.white.opacity(0.14), .white.opacity(0.07)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
        }
    }
}

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
