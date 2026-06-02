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

    func startDailyChallenge(_ challenge: DailyChallenge = .today()) {
        activeSession = GameSession(
            profile: playerProfile,
            seed: challenge.seed,
            dailyChallenge: challenge
        )
        currentScreen = .run
    }

    func retryLastRun() {
        if let challenge = lastRunResult?.dailyChallenge {
            startDailyChallenge(challenge)
        } else {
            startRun()
        }
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

    func purchaseUpgrade(_ upgrade: UpgradeID) -> Bool {
        guard playerProfile.purchase(upgrade) else {
            return false
        }

        persistProfile()
        return true
    }

    func setSoundEnabled(_ isEnabled: Bool) {
        playerProfile.setSoundEnabled(isEnabled)
        persistProfile()
    }

    func setHapticsEnabled(_ isEnabled: Bool) {
        playerProfile.setHapticsEnabled(isEnabled)
        persistProfile()
    }

    func persistProfile() {
        profileStore.saveProfile(playerProfile)
    }
}

struct ContentView: View {
    @State private var appModel = AppModel()
    @State private var feedbackSystem = GameFeedbackSystem()
    @State private var isShowingSplash = true

    var body: some View {
        ZStack {
            Group {
                switch appModel.currentScreen {
                case .home:
                    HomeView(
                        profile: appModel.playerProfile,
                        onStartRun: {
                            feedbackSystem.play(.move, settings: appModel.playerProfile.feedbackSettings)
                            appModel.startRun()
                        },
                        onStartDailyChallenge: {
                            feedbackSystem.play(.move, settings: appModel.playerProfile.feedbackSettings)
                            appModel.startDailyChallenge()
                        },
                        onOpenUpgrades: {
                            feedbackSystem.play(.move, settings: appModel.playerProfile.feedbackSettings)
                            appModel.showUpgrades()
                        },
                        onOpenHelp: {
                            feedbackSystem.play(.move, settings: appModel.playerProfile.feedbackSettings)
                            appModel.showHelp()
                        },
                        onSoundEnabledChanged: { isEnabled in
                            appModel.setSoundEnabled(isEnabled)
                            feedbackSystem.play(.toggle, settings: appModel.playerProfile.feedbackSettings)
                        },
                        onHapticsEnabledChanged: { isEnabled in
                            appModel.setHapticsEnabled(isEnabled)
                            feedbackSystem.play(.toggle, settings: appModel.playerProfile.feedbackSettings)
                        }
                    )
                case .upgrades:
                    UpgradeView(
                        profile: appModel.playerProfile,
                        onPurchase: { upgrade in
                            if appModel.purchaseUpgrade(upgrade) {
                                feedbackSystem.play(.upgradePurchase, settings: appModel.playerProfile.feedbackSettings)
                            }
                        },
                        onBack: appModel.showHome
                    )
                case .help:
                    ZStack {
                        HomeView(
                            profile: appModel.playerProfile,
                            onStartRun: appModel.startRun,
                            onStartDailyChallenge: {
                                appModel.startDailyChallenge()
                            },
                            onOpenUpgrades: appModel.showUpgrades,
                            onOpenHelp: appModel.showHelp,
                            onSoundEnabledChanged: appModel.setSoundEnabled,
                            onHapticsEnabledChanged: appModel.setHapticsEnabled
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
                            feedbackSystem: feedbackSystem,
                            feedbackSettings: appModel.playerProfile.feedbackSettings,
                            onBackToMenu: appModel.showHome,
                            onFinishRun: appModel.finishRun
                        )
                    } else {
                        HomeView(
                            profile: appModel.playerProfile,
                            onStartRun: appModel.startRun,
                            onStartDailyChallenge: {
                                appModel.startDailyChallenge()
                            },
                            onOpenUpgrades: appModel.showUpgrades,
                            onOpenHelp: appModel.showHelp,
                            onSoundEnabledChanged: appModel.setSoundEnabled,
                            onHapticsEnabledChanged: appModel.setHapticsEnabled
                        )
                    }
                case .results:
                    if let result = appModel.lastRunResult {
                        ResultsView(
                            result: result,
                            profile: appModel.playerProfile,
                            onRetry: appModel.retryLastRun,
                            onOpenUpgrades: appModel.showUpgrades,
                            onBackToMenu: appModel.showHome
                        )
                    } else {
                        HomeView(
                            profile: appModel.playerProfile,
                            onStartRun: appModel.startRun,
                            onStartDailyChallenge: {
                                appModel.startDailyChallenge()
                            },
                            onOpenUpgrades: appModel.showUpgrades,
                            onOpenHelp: appModel.showHelp,
                            onSoundEnabledChanged: appModel.setSoundEnabled,
                            onHapticsEnabledChanged: appModel.setHapticsEnabled
                        )
                    }
                }
            }

            if isShowingSplash {
                SplashView()
                    .transition(.opacity.combined(with: .scale(scale: 1.02)))
                    .zIndex(1)
            }
        }
        .onChange(of: appModel.playerProfile) {
            appModel.persistProfile()
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1450))
            withAnimation(.easeOut(duration: 0.35)) {
                isShowingSplash = false
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.86), value: appModel.currentScreen)
    }
}

#Preview {
    ContentView()
}
