import Foundation

extension Notification.Name {
    static let sessionDidChange = Notification.Name("beast.sessionDidChange")
}

final class AppStorageManager {
    static let shared = AppStorageManager()

    private enum Keys {
        static let isLoggedIn = "beast.isLoggedIn"
        static let profile = "beast.profile"
    }

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    var isLoggedIn: Bool {
        get {
            userDefaults.bool(forKey: Keys.isLoggedIn)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isLoggedIn)

            NotificationCenter.default.post(
                name: .sessionDidChange,
                object: nil
            )
        }
    }

    func saveProfile(_ profile: AllDataProfileUserSystem) {
        do {
            let data = try encoder.encode(profile)
            userDefaults.set(data, forKey: Keys.profile)
        } catch {
            print("Error saving profile: \(error)")
        }
    }

    func getProfile() -> AllDataProfileUserSystem? {
        guard let data = userDefaults.data(forKey: Keys.profile) else {
            return nil
        }

        do {
            return try decoder.decode(
                AllDataProfileUserSystem.self,
                from: data
            )
        } catch {
            print("Error loading profile: \(error)")
            return nil
        }
    }

    func clearProfile() {
        userDefaults.removeObject(forKey: Keys.profile)
    }

    func clearSession() {
        userDefaults.set(false, forKey: Keys.isLoggedIn)
        userDefaults.removeObject(forKey: Keys.profile)

        NotificationCenter.default.post(
            name: .sessionDidChange,
            object: nil
        )
    }
}
