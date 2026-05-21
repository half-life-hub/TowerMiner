import SwiftUI

struct SplashView: View {
    @State private var hasAppeared = false

    var body: some View {
        ZStack {
            SplashBackground()

            VStack(spacing: 18) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 330)
                    .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.34), radius: 18)
                    .scaleEffect(hasAppeared ? 1 : 0.94)
                    .opacity(hasAppeared ? 1 : 0)

                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.42))
                        .frame(width: 126, height: 126)

                    Circle()
                        .strokeBorder(Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.42), lineWidth: 2)
                        .frame(width: 126, height: 126)

                    Image("player_miner")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 112, height: 112)
                        .shadow(color: Color(red: 0.52, green: 0.94, blue: 0.86).opacity(0.55), radius: 12)
                }
                .offset(y: hasAppeared ? 0 : 10)
                .opacity(hasAppeared ? 1 : 0)

                Text("DIG DEEP. BANK THE HAUL.")
                    .font(.caption.weight(.black))
                    .tracking(1.4)
                    .foregroundStyle(.white.opacity(0.64))
                    .opacity(hasAppeared ? 1 : 0)
            }
            .padding(.horizontal, 28)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tower Miner")
        .onAppear {
            withAnimation(.smooth(duration: 0.55)) {
                hasAppeared = true
            }
        }
    }
}

private struct SplashBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.06, blue: 0.10),
                    Color(red: 0.13, green: 0.15, blue: 0.17)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { column in
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(.white.opacity((row + column).isMultiple(of: 3) ? 0.030 : 0.016), lineWidth: 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color(red: 0.16, green: 0.17, blue: 0.18).opacity((row + column).isMultiple(of: 4) ? 0.14 : 0.06))
                                )
                                .frame(height: 82)
                        }
                    }
                }
            }
            .opacity(0.56)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SplashView()
}
