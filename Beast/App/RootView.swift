import SwiftUI

struct RootView: View {
    @State private var hasCompletedOnboarding: Bool
    @State private var isLoggedIn: Bool

    private let onboardingPreferences: OnboardingPreferencesProtocol
    private let storage: AppStorageManager

    init(
        onboardingPreferences: OnboardingPreferencesProtocol = OnboardingPreferences.shared,
        storage: AppStorageManager = .shared
    ) {
        self.onboardingPreferences = onboardingPreferences
        self.storage = storage

        _hasCompletedOnboarding = State(
            initialValue: onboardingPreferences.hasCompletedOnboarding
        )

        _isLoggedIn = State(
            initialValue: storage.isLoggedIn
        )
    }

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView {
                    completeOnboarding()
                }
                .transition(.opacity)

            } else if !isLoggedIn {
                LoginView()
                    .transition(.opacity)

            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: hasCompletedOnboarding
        )
        .animation(
            .easeInOut(duration: 0.3),
            value: isLoggedIn
        )
        .onReceive(
            NotificationCenter.default.publisher(
                for: .sessionDidChange
            )
        ) { _ in
            isLoggedIn = storage.isLoggedIn
        }
    }

    private func completeOnboarding() {
        onboardingPreferences.completeOnboarding()

        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    RootView()
}
