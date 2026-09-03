import SwiftUI

struct OnboardingPageIndicator: View {
    let pageCount: Int
    let selectedPage: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(
                        index == selectedPage
                        ? Color("BeastOnboardingAccent")
                        : Color.white.opacity(0.35)
                    )
                    .frame(
                        width: index == selectedPage ? 26 : 5,
                        height: 5
                    )
                    .animation(
                        .easeInOut(duration: 0.25),
                        value: selectedPage
                    )
            }
        }
    }
}
