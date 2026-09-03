import SwiftUI

struct CheckInNipCard: View {
    let nip: String

    var body: some View {
        VStack(spacing: 12) {
            Text("ENTRADA MANUAL NIP")
                .font(
                    .system(
                        size: 11,
                        weight: .bold
                    )
                )
                .tracking(2)
                .foregroundStyle(
                    BeastColors.textSecondary
                )

            Text(nip)
                .font(
                    .system(
                        size: 36,
                        weight: .black
                    )
                )
                .italic()
                .tracking(-1)
                .foregroundStyle(
                    BeastColors.primary
                )
                .frame(
                    width: 220,
                    height: 60
                )
                .background(
                    BeastColors.surface
                )
                .clipShape(
                    Capsule()
                )
        }
    }
}
