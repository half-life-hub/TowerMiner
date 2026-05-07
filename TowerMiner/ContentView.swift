import Observation
import SwiftUI

@Observable
final class AppModel {
    var currentScreen: AppScreen = .home
    var playerProfile: PlayerProfile
    var activeSession: GameSession?

    private let profileStore: ProfileStore

    init(profileStore: ProfileStore = ProfileStore()) {
        self.profileStore = profileStore
        self.playerProfile = profileStore.loadProfile()
    }

    func startRun() {
        activeSession = GameSession(profile: playerProfile)
        currentScreen = .run
    }

    func showHome() {
        activeSession = nil
        currentScreen = .home
    }

    func showUpgrades() {
        currentScreen = .upgrades
    }

    func persistProfile() {
        profileStore.saveProfile(playerProfile)
    }
}

struct ContentView: View {
    @State private var appModel = AppModel()

    var body: some View {
        Group {
            switch appModel.currentScreen {
            case .home:
                HomeView(
                    profile: appModel.playerProfile,
                    onStartRun: appModel.startRun,
                    onOpenUpgrades: appModel.showUpgrades
                )
            case .upgrades:
                UpgradeView(
                    profile: appModel.playerProfile,
                    onBack: appModel.showHome
                )
            case .run:
                if let session = appModel.activeSession {
                    RunView(
                        session: session,
                        onBackToMenu: appModel.showHome
                    )
                } else {
                    HomeView(
                        profile: appModel.playerProfile,
                        onStartRun: appModel.startRun,
                        onOpenUpgrades: appModel.showUpgrades
                    )
                }
            }
        }
        .onChange(of: appModel.playerProfile) {
            appModel.persistProfile()
        }
    }
}

#Preview {
    ContentView()
}
