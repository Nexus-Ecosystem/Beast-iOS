import SwiftUI

struct ScheduleDaysSelector: View {
    let selectedDate: Date
    let onSelectDate: (Date) -> Void

    private let calendar = Calendar.current

    private let selectedTopColor = Color(
        red: 0.70,
        green: 1.0,
        blue: 0.20
    )

    private let selectedBottomColor = Color(
        red: 0.16,
        green: 0.94,
        blue: 0.75
    )

    private var dates: [Date] {
        (0..<31).compactMap {
            calendar.date(
                byAdding: .day,
                value: $0,
                to: Date()
            )
        }
    }

    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack(spacing: 10) {
                ForEach(
                    dates,
                    id: \.self
                ) { date in
                    dayItem(date)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private func dayItem(
        _ date: Date
    ) -> some View {
        let isSelected = calendar.isDate(
            date,
            inSameDayAs: selectedDate
        )

        return Button {
            onSelectDate(date)
        } label: {
            VStack(spacing: 6) {
                Text(dayName(date))
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(
                        isSelected
                        ? Color.black.opacity(0.65)
                        : Color.secondary
                    )

                Text(dayNumber(date))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(
                        isSelected
                        ? Color.black
                        : Color.primary
                    )

                Circle()
                    .fill(
                        isSelected
                        ? Color.black
                        : Color.clear
                    )
                    .frame(width: 4, height: 4)
            }
            .frame(
                width: 58,
                height: 66
            )
            .background {
                if isSelected {
                    LinearGradient(
                        colors: [
                            selectedTopColor,
                            selectedBottomColor
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else {
                    Color(.secondarySystemBackground)
                }
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 26
                )
            )
        }
        .buttonStyle(.plain)
    }

    private func dayName(
        _ date: Date
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "EEE"

        let value = formatter.string(from: date)
            .replacingOccurrences(
                of: ".",
                with: ""
            )

        return value.prefix(1).uppercased()
            + value.dropFirst().lowercased()
    }

    private func dayNumber(
        _ date: Date
    ) -> String {
        String(
            calendar.component(
                .day,
                from: date
            )
        )
    }
}
