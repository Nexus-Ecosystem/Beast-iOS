import SwiftUI

struct ProfilePoweredByNexus: View {
    var body: some View {
        HStack(
            spacing: 7
        ) {
            Image("logo_nexus")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 38,
                    height: 38
                )

            Text("By")
                .font(
                    .system(
                        size: 11,
                        weight: .light
                    )
                )
                .foregroundStyle(
                    .secondary
                )

            Text(
                "Nexus Ecosystem"
            )
            .font(
                .system(
                    size: 13,
                    weight: .bold
                )
            )
        }
        .frame(
            maxWidth: .infinity
        )
    }
}
