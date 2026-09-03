import SwiftUI

struct OnboardingContentCard: View {
    let page: OnboardingPage
    let pageCount: Int
    let selectedPage: Int
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            OnboardingPageIndicator(
                pageCount: pageCount,
                selectedPage: selectedPage
            )
            .padding(.top, 18)

            Text(page.step)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color("BeastOnboardingAccent"))
                .padding(.top, 11)

            VStack(spacing: 0) {
                Text(page.title)
                    .foregroundStyle(.white)

                Text(page.highlightedTitle)
                    .foregroundStyle(Color("BeastOnboardingAccent"))
            }
            .font(.system(size: 25, weight: .black))
            .italic()
            .multilineTextAlignment(.center)
            .padding(.top, 7)

            Text(page.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.white.opacity(0.62))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 28)
                .padding(.top, 14)

            Spacer(minLength: 18)

            Button(action: action) {
                HStack(spacing: 10) {
                    Text(page.buttonTitle)

                    Image(systemName: page.buttonIcon)
                        .font(.system(size: 13, weight: .bold))
                }
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color("BeastOnboardingAccent"))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.bottom, 26)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(Color("BeastOnboardingCard"))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 28,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 28
            )
        )
    }
}
