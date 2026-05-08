import SwiftUI

struct HomeView: View {
    let profile: PlayerProfile
    let onStartRun: () -> Void
    let onOpenUpgrades: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.06, green: 0.08, blue: 0.14), Color(red: 0.16, green: 0.08, blue: 0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Tower Miner")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.32), radius: 12)

                    Text("Dig deeper, cash out, and come back stronger.")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 14) {
                    StatCard(title: "Total Credits", value: "\(profile.totalCredits)")
                    StatCard(title: "Best Depth", value: "\(profile.bestDepth)")
                }
                .padding(.top, 8)

                VStack(spacing: 12) {
                    Button("Start Run", action: onStartRun)
                        .buttonStyle(PrimaryGameButtonStyle())

                    Button("Upgrades", action: onOpenUpgrades)
                        .buttonStyle(SecondaryGameButtonStyle())
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.75))
            Spacer()
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private struct PrimaryGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(red: 0.55, green: 0.92, blue: 0.88), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private struct SecondaryGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    HomeView(
        profile: .default,
        onStartRun: {},
        onOpenUpgrades: {}
    )
}
