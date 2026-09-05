import SwiftUI

struct ProfileMenuCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(
            spacing: 0,
            content: content
        )
        .frame(
            maxWidth: .infinity
        )
        .background(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(
                Color(
                    .secondarySystemBackground
                )
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }
}
