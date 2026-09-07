import SwiftUI

struct HistoryFilterView: View {
    @Binding var selectedFilter: HistoryFilter

    let onSelect: (
        HistoryFilter
    ) -> Void

    var body: some View {
        HStack(
            spacing: 6
        ) {
            ForEach(
                HistoryFilter.allCases
            ) { filter in
                Button {
                    onSelect(
                        filter
                    )
                } label: {
                    Text(
                        filter.rawValue
                    )
                    .font(
                        .system(
                            size: 11,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        selectedFilter == filter
                        ? BeastColors.buttonText
                        : BeastColors.textSecondary
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 38
                    )
                    .background(
                        Capsule()
                            .fill(
                                selectedFilter == filter
                                ? BeastColors.primary
                                : BeastColors.surface
                            )
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                selectedFilter == filter
                                ? Color.clear
                                : BeastColors.border,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(
                    .plain
                )
            }
        }
    }
}
