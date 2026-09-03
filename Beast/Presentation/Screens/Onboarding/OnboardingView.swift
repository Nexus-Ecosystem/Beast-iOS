import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    let onFinished: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                imagePager(geometry: geometry)

                fixedLogo(geometry: geometry)

                OnboardingContentCard(
                    page: viewModel.currentPage,
                    pageCount: viewModel.pages.count,
                    selectedPage: viewModel.selectedPage,
                    action: handleAction
                )
            }
            .background(Color.black)
            .ignoresSafeArea()
        }
    }

    private func imagePager(geometry: GeometryProxy) -> some View {
        TabView(selection: $viewModel.selectedPage) {
            ForEach(viewModel.pages) { page in
                ZStack {
                    Image(page.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                        .clipped()

                    Color.black
                        .opacity(0.40)
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .tag(page.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }

    private func fixedLogo(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image("beast_logo_white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125)

                Spacer()
            }
            .padding(.horizontal, 28)

            Spacer()
        }
        .padding(.top, geometry.safeAreaInsets.top + 18)
        .allowsHitTesting(false)
    }

    private func handleAction() {
        if viewModel.isLastPage {
            onFinished()
        } else {
            viewModel.nextPage()
        }
    }
}

#Preview {
    OnboardingView {}
}
