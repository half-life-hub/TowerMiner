import SwiftUI

struct RunView: View {
    let preview: RunPreview
    let onBackToMenu: () -> Void

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
                    Text("Run Preview")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button("Menu", action: onBackToMenu)
                        .buttonStyle(.borderedProminent)
                }

                VStack(spacing: 12) {
                    PreviewRow(title: "Starting Health", value: "\(preview.startingHealth)")
                    PreviewRow(title: "Starting Energy", value: "\(preview.startingEnergy)")
                    PreviewRow(title: "Starting Bombs", value: "\(preview.startingBombs)")
                    PreviewRow(title: "Starting Shields", value: "\(preview.startingShields)")
                }

                Text("Gameplay grid and controls land in Milestone 2.")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.72))

                Spacer()
            }
            .padding(24)
        }
    }
}

private struct PreviewRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.72))
            Spacer()
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    RunView(
        preview: RunPreview(startingHealth: 5, startingEnergy: 10, startingBombs: 1, startingShields: 1),
        onBackToMenu: {}
    )
}
