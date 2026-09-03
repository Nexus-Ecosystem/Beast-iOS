import SwiftUI

struct ClassHistorySection: View {
    let reservations: [ClassItemEntity]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("HISTÓRICO")
                    .font(
                        .system(
                            size: 24,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Spacer()

                Button {
                } label: {
                    Text("VER TODO")
                        .font(
                            .system(
                                size: 10,
                                weight: .black
                            )
                        )
                        .tracking(1)
                        .foregroundStyle(
                            BeastColors.primary
                        )
                }
                .buttonStyle(.plain)
            }

            ForEach(
                reservations
            ) { reservation in
                ClassHistoryItem(
                    reservation: reservation
                )
            }
        }
    }
}
