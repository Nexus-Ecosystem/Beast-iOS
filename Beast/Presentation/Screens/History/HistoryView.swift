import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                header

                HistoryFilterView(
                    selectedFilter: $viewModel.selectedFilter
                ) { filter in
                    viewModel.selectFilter(
                        filter
                    )
                }
                .padding(
                    .top,
                    18
                )

                HistoryPeriodSelector(
                    title: viewModel.periodTitle,
                    previous: {
                        viewModel.previousPeriod()
                    },
                    next: {
                        viewModel.nextPeriod()
                    }
                )
                .padding(
                    .top,
                    14
                )
                .padding(
                    .bottom,
                    16
                )

                Divider()
                    .overlay(
                        BeastColors.border
                    )

                historyContent
            }
            .padding(
                .horizontal,
                24
            )

            if viewModel.isLoading {
                BeastLoadingOverlay()
            }

            if let error = viewModel.errorMessage {
                BeastAlertDialog(
                    style: .error,
                    message: error
                ) {
                    viewModel.resetError()
                }
                .zIndex(20)
            }
        }
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(
            .inline
        )
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            Text(
                "TU ACTIVIDAD"
            )
            .font(
                .system(
                    size: 11,
                    weight: .bold
                )
            )
            .tracking(2)
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "HISTÓRICO"
            )
            .font(
                .system(
                    size: 32,
                    weight: .black
                )
            )
            .italic()
            .foregroundStyle(
                BeastColors.textPrimary
            )

            Text(
                "Consulta las clases que has tomado y tus reservaciones anteriores."
            )
            .font(
                .system(
                    size: 13
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
        }
        .padding(
            .top,
            12
        )
    }

    @ViewBuilder
    private var historyContent: some View {
        if viewModel.filteredReservations.isEmpty &&
            !viewModel.isLoading {
            emptyState
        } else {
            ScrollView(
                showsIndicators: false
            ) {
                LazyVStack(
                    spacing: 12
                ) {
                    ForEach(
                        Array(
                            viewModel.filteredReservations.enumerated()
                        ),
                        id: \.offset
                    ) { _, reservation in
                        HistoryReservationCard(
                            reservation: reservation
                        )
                    }

                    Spacer()
                        .frame(
                            height: 24
                        )
                }
                .padding(
                    .top,
                    16
                )
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    private var emptyState: some View {
        VStack(
            spacing: 18
        ) {
            Spacer()

            Image(
                systemName: "clock.arrow.circlepath"
            )
            .font(
                .system(
                    size: 34,
                    weight: .medium
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "NO HAY CLASES"
            )
            .font(
                .system(
                    size: 18,
                    weight: .black
                )
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )

            Text(
                emptyMessage
            )
            .font(
                .system(
                    size: 12
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(
                .center
            )
            .lineSpacing(4)

            Spacer()
        }
        .frame(
            maxWidth: .infinity
        )
    }

    private var emptyMessage: String {
        switch viewModel.selectedFilter {
        case .week:
            return "No tienes clases registradas durante esta semana."

        case .month:
            return "No tienes clases registradas durante este mes."

        case .year:
            return "No tienes clases registradas durante este año."
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
