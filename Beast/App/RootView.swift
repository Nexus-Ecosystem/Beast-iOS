import SwiftUI

struct RootView: View {
    @State private var hasCompletedOnboarding: Bool
    @State private var isLoggedIn: Bool
    @State private var needsBranch: Bool

    @AppStorage("dark_mode")
    private var darkMode = false

    private let onboardingPreferences: OnboardingPreferencesProtocol
    private let storage: AppStorageManager

    init(
        onboardingPreferences: OnboardingPreferencesProtocol = OnboardingPreferences.shared,
        storage: AppStorageManager = .shared
    ) {
        self.onboardingPreferences = onboardingPreferences
        self.storage = storage

        let loggedIn = storage.isLoggedIn
        let profile = storage.getProfile()

        _hasCompletedOnboarding = State(
            initialValue: onboardingPreferences.hasCompletedOnboarding
        )

        _isLoggedIn = State(
            initialValue: loggedIn
        )

        _needsBranch = State(
            initialValue:
                loggedIn &&
                (profile?.branches.isEmpty ?? true)
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

            } else if needsBranch {
                NavigationStack {
                    FindBranchView {
                        branchSelectionCompleted()
                    }
                }
                .transition(.opacity)

            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(
            darkMode
                ? .dark
                : .light
        )
        .animation(
            .easeInOut(duration: 0.3),
            value: hasCompletedOnboarding
        )
        .animation(
            .easeInOut(duration: 0.3),
            value: isLoggedIn
        )
        .animation(
            .easeInOut(duration: 0.3),
            value: needsBranch
        )
        .onAppear {
            refreshSessionState()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .sessionDidChange
            )
        ) { _ in
            refreshSessionState()
        }
    }

    private func completeOnboarding() {
        onboardingPreferences.completeOnboarding()

        withAnimation {
            hasCompletedOnboarding = true
        }
    }

    private func refreshSessionState() {
        let loggedIn = storage.isLoggedIn

        isLoggedIn = loggedIn

        guard loggedIn else {
            needsBranch = false
            return
        }

        guard let profile = storage.getProfile() else {
            needsBranch = true
            return
        }

        needsBranch = profile.branches.isEmpty
    }

    private func branchSelectionCompleted() {
        refreshSessionState()
    }
}

#Preview {
    RootView()
}
