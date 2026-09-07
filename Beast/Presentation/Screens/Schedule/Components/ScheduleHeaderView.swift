import SwiftUI

struct ScheduleHeaderView: View {
    let date: Date

    var body: some View {
        HStack(alignment: .center) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(date.scheduleMonthTitle)
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )

                Text("Horarios del mes")
                    .font(
                        .system(
                            size: 30,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(
                        BeastColors.surface
                    )
                    .frame(
                        width: 48,
                        height: 48
                    )

                Image(systemName: "calendar")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
}
