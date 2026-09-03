import Foundation

protocol OnboardingPreferencesProtocol {
    var hasCompletedOnboarding: Bool { get }
    func completeOnboarding()
    func resetOnboarding()
}

final class OnboardingPreferences: OnboardingPreferencesProtocol {
    static let shared = OnboardingPreferences()

    private enum Keys {
        static let hasCompletedOnboarding = "beast.hasCompletedOnboarding"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var hasCompletedOnboarding: Bool {
        userDefaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    func completeOnboarding() {
        userDefaults.set(true, forKey: Keys.hasCompletedOnboarding)
    }

    func resetOnboarding() {
        userDefaults.removeObject(forKey: Keys.hasCompletedOnboarding)
    }
}
