import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            content
                .overlay(alignment: .bottomTrailing) {
                    qrScannerButton
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                }

            if viewModel.isLoading {
                BeastLoadingOverlay()
                    .zIndex(20)
            }

            if let error = viewModel.errorMessage {
                BeastAlertDialog(
                    style: .error,
                    message: error
                ) {
                    viewModel.resetError()
                }
                .zIndex(30)
            }
        }
        .task {
            await viewModel.load()
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 24) {
                HomeDateHeader()

                if let upcomingClass = viewModel.upcomingClass {
                    UpcomingClassCard(
                        reservation: upcomingClass
                    )
                } else {
                    EmptyUpcomingClassCard()
                }

                if viewModel.classHistory.isEmpty {
                    EmptyClassHistoryCard()
                } else {
                    ClassHistorySection(
                        reservations: viewModel.classHistory
                    )
                }

                Spacer()
                    .frame(height: 80)
            }
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
    }

    private var qrScannerButton: some View {
        Button {
            // TODO: abrir QR Scanner
        } label: {
            Image(systemName: "qrcode.viewfinder")
                .font(
                    .system(
                        size: 26,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    width: 58,
                    height: 58
                )
                .background(
                    BeastColors.primary
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14,
                        style: .continuous
                    )
                )
                .shadow(
                    color: Color.black.opacity(0.20),
                    radius: 8,
                    x: 0,
                    y: 5
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
