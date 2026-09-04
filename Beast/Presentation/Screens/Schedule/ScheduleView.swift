import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel

    let onSelectBike: (
        ClassItem,
        String,
        String
    ) -> Void

    init(
        viewModel: ScheduleViewModel,
        onSelectBike: @escaping (
            ClassItem,
            String,
            String
        ) -> Void = { _, _, _ in }
    ) {
        self.viewModel = viewModel
        self.onSelectBike = onSelectBike
    }

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                LazyVStack(spacing: 0) {
                    ScheduleHeaderView(
                        date: viewModel.selectedDate
                    )

                    ScheduleDaysSelector(
                        selectedDate: viewModel.selectedDate,
                        onSelectDate: { date in
                            viewModel.selectDate(date)
                        }
                    )
                    .padding(.top, 16)

                    if viewModel.hasSchedules {
                        scheduleList
                    } else if !viewModel.isLoading {
                        ScheduleEmptyStateView()
                            .padding(.top, 48)
                    }

                    Spacer()
                        .frame(height: 120)
                }
            }

            if viewModel.isLoading {
                ScheduleLoadingView()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var scheduleList: some View {
        LazyVStack(spacing: 16) {
            ForEach(
                viewModel.visibleSchedules
            ) { item in
                ScheduleClassCard(
                    item: item,
                    isExtraBooking: viewModel.isExtraBooking(
                        item
                    ),
                    canCancel: viewModel.canCancel(
                        item
                    ),
                    onAction: {
                        viewModel.selectClass(
                            item
                        )
                    },
                    onSelectBike: {
                        onSelectBike(
                            item,
                            viewModel.selectedDate.scheduleDay,
                            viewModel.selectedDate.scheduleMonth
                        )
                    }
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
}
