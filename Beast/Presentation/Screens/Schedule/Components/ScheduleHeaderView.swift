import SwiftUI

struct ScheduleHeaderView: View {
    let date: Date

    private let purple = Color(
        red: 0.46,
        green: 0.27,
        blue: 1.0
    )

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
                    .foregroundStyle(purple)

                Text("Horarios del mes")
                    .font(
                        .system(
                            size: 30,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(.primary)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(
                        Color(.secondarySystemBackground)
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
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
}
