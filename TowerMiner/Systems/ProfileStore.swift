import Foundation

struct ProfileStore {
    private let defaults: UserDefaults
    private let profileKey = "towerminer.playerProfile"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadProfile() -> PlayerProfile {
        guard let data = defaults.data(forKey: profileKey) else {
            return .default
        }

        do {
            return try JSONDecoder().decode(PlayerProfile.self, from: data)
        } catch {
            return .default
        }
    }

    func saveProfile(_ profile: PlayerProfile) {
        guard let data = try? JSONEncoder().encode(profile) else {
            return
        }

        defaults.set(data, forKey: profileKey)
    }
}
