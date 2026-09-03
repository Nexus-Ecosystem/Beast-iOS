// Path: Presentation/Auth/Login/Components/LoginBackgroundView.swift

import SwiftUI

struct LoginBackgroundView: View {

    var body: some View {
        ZStack {
            Image("login_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.18)

            LinearGradient(
                colors: [
                    BeastColors.background.opacity(0.62),
                    BeastColors.background.opacity(0.58),
                    BeastColors.background.opacity(0.86)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    BeastColors.primary.opacity(0.08),
                    Color.clear,
                    BeastColors.background.opacity(0.78)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}
