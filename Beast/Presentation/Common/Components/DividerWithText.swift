import SwiftUI

struct DividerWithText: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color("BeastBorder"))
                .frame(height: 1)

            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color("BeastTextSecondary"))
                .fixedSize()

            Rectangle()
                .fill(Color("BeastBorder"))
                .frame(height: 1)
        }
    }
}
