import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var selectedPage: Int = 0

    let pages: [OnboardingPage]

    init(pages: [OnboardingPage] = OnboardingPage.pages) {
        self.pages = pages
    }

    var currentPage: OnboardingPage {
        pages[selectedPage]
    }

    var isLastPage: Bool {
        selectedPage == pages.count - 1
    }

    func nextPage() {
        guard !isLastPage else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            selectedPage += 1
        }
    }
}
