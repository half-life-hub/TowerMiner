import Foundation
import WidgetKit

struct ProfileStore {
    private let defaults: UserDefaults
    private let fallbackDefaults: UserDefaults?
    private let profileKey = "towerminer.playerProfile"
    private let reloadsWidgetsOnSave: Bool

    init() {
        self.init(
            defaults: UserDefaults(suiteName: "group.au.tower.miner") ?? .standard,
            fallbackDefaults: .standard,
            reloadsWidgetsOnSave: true
        )
    }

    init(defaults: UserDefaults, reloadsWidgetsOnSave: Bool = true) {
        self.init(defaults: defaults, fallbackDefaults: nil, reloadsWidgetsOnSave: reloadsWidgetsOnSave)
    }

    private init(defaults: UserDefaults, fallbackDefaults: UserDefaults?, reloadsWidgetsOnSave: Bool) {
        self.defaults = defaults
        self.fallbackDefaults = fallbackDefaults
        self.reloadsWidgetsOnSave = reloadsWidgetsOnSave
    }

    func loadProfile() -> PlayerProfile {
        if let profile = loadProfile(from: defaults) {
            return profile
        }

        if let fallbackDefaults, let migratedProfile = loadProfile(from: fallbackDefaults) {
            saveProfile(migratedProfile)
            return migratedProfile
        }

        return .default
    }

    func saveProfile(_ profile: PlayerProfile) {
        guard let data = try? JSONEncoder().encode(profile) else {
            return
        }

        defaults.set(data, forKey: profileKey)
        if reloadsWidgetsOnSave {
            WidgetCenter.shared.reloadTimelines(ofKind: "TowerMinerWidget")
        }
    }

    private func loadProfile(from defaults: UserDefaults) -> PlayerProfile? {
        guard let data = defaults.data(forKey: profileKey) else {
            return nil
        }

        return try? JSONDecoder().decode(PlayerProfile.self, from: data)
    }
}
