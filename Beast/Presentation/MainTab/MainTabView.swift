import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea(.all)

            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Image(systemName: MainTab.home.icon)
                }
                .tag(MainTab.home)

                NavigationStack {
                    ScheduleView()
                }
                .tabItem {
                    Image(systemName: MainTab.schedule.icon)
                }
                .tag(MainTab.schedule)

                NavigationStack {
                    PackagesView()
                }
                .tabItem {
                    Image(systemName: MainTab.packages.icon)
                }
                .tag(MainTab.packages)

                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Image(systemName: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
            }
            .tint(Color("BeastTabSelected"))
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            configureTabBar()
        }
        .onChange(of: colorScheme) { _, _ in
            configureTabBar()
        }
    }

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor(Color("BeastTabBackground")).withAlphaComponent(0.94)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.05)

        let itemAppearance = UITabBarItemAppearance()

        itemAppearance.normal.iconColor = UIColor(Color("BeastTabUnselected"))
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 1)
        ]
        itemAppearance.normal.titlePositionAdjustment = UIOffset(
            horizontal: 0,
            vertical: 100
        )

        itemAppearance.selected.iconColor = UIColor(Color("BeastTabSelected"))
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 1)
        ]
        itemAppearance.selected.titlePositionAdjustment = UIOffset(
            horizontal: 0,
            vertical: 100
        )

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().itemPositioning = .fill
    }
}
