import SwiftUI

struct HomeDateHeader: View {
    private var formattedDate: String {
        let formatter = DateFormatter()

        formatter.locale = Locale(
            identifier: "es_MX"
        )

        formatter.dateFormat = "d 'de' MMMM 'del' yyyy"

        return formatter.string(
            from: Date()
        )
    }

    var body: some View {
        HStack {
            Text(formattedDate)
                .font(
                    .system(
                        size: 22,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.primary
                )

            Spacer()
        }
        .padding(.top, 16)
    }
}
