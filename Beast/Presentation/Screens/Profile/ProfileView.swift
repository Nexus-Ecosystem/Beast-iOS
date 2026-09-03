import SwiftUI

struct ProfileView: View {

    @AppStorage("isDarkModeEnabled")
    private var isDarkModeEnabled = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                BeastProfileColors.background
                    .ignoresSafeArea(.all)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        ProfileAvatarView()

                        ProfileSubscriptionCardView()

                        ProfileOptionsSectionView(
                            isDarkMode: $isDarkModeEnabled
                        )

                        ProfileLogoutButtonView()

                        ProfileNexusFooterView()
                            .padding(.top, 6)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 108)
                    .padding(.bottom, 24)
                }
                .scrollContentBackground(.hidden)

                ProfileHeaderView()
            }
            .navigationBarHidden(true)
        }
    }
}
