import Observation
import SwiftUI

@Observable
final class AppModel {
    var currentScreen: AppScreen = .home
    var playerProfile: PlayerProfile
    var activeSession: GameSession?
    var lastRunResult: RunResult?

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

    func showHelp() {
        currentScreen = .help
    }

    func finishRun(_ result: RunResult) {
        lastRunResult = result
        activeSession = nil
        playerProfile.apply(result)
        persistProfile()
        currentScreen = .results
    }

    func purchaseUpgrade(_ upgrade: UpgradeID) {
        guard playerProfile.purchase(upgrade) else {
            return
        }

        persistProfile()
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
                    onOpenUpgrades: appModel.showUpgrades,
                    onOpenHelp: appModel.showHelp
                )
            case .upgrades:
                UpgradeView(
                    profile: appModel.playerProfile,
                    onPurchase: appModel.purchaseUpgrade,
                    onBack: appModel.showHome
                )
            case .help:
                ZStack {
                    HomeView(
                        profile: appModel.playerProfile,
                        onStartRun: appModel.startRun,
                        onOpenUpgrades: appModel.showUpgrades,
                        onOpenHelp: appModel.showHelp
                    )

                    HelpView(onClose: appModel.showHome)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom),
                                removal: .move(edge: .bottom)
                            )
                        )
                }
            case .run:
                if let session = appModel.activeSession {
                    RunView(
                        session: session,
                        onBackToMenu: appModel.showHome,
                        onFinishRun: appModel.finishRun
                    )
                } else {
                    HomeView(
                        profile: appModel.playerProfile,
                        onStartRun: appModel.startRun,
                        onOpenUpgrades: appModel.showUpgrades,
                        onOpenHelp: appModel.showHelp
                    )
                }
            case .results:
                if let result = appModel.lastRunResult {
                    ResultsView(
                        result: result,
                        profile: appModel.playerProfile,
                        onRetry: appModel.startRun,
                        onOpenUpgrades: appModel.showUpgrades,
                        onBackToMenu: appModel.showHome
                    )
                } else {
                    HomeView(
                        profile: appModel.playerProfile,
                        onStartRun: appModel.startRun,
                        onOpenUpgrades: appModel.showUpgrades,
                        onOpenHelp: appModel.showHelp
                    )
                }
            }
        }
        .onChange(of: appModel.playerProfile) {
            appModel.persistProfile()
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.86), value: appModel.currentScreen)
    }
}

#Preview {
    ContentView()
}
