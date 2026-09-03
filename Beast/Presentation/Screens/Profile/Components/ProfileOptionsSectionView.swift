import SwiftUI

struct ProfileOptionsSectionView: View {

    @Binding var isDarkMode: Bool

    var body: some View {
        VStack(spacing: 14) {
            ProfileOptionRowView(
                icon: "shield.checkered",
                title: "Políticas",
                trailing: nil,
                showChevron: true
            )

            ProfileOptionRowView(
                icon: "globe.americas.fill",
                title: "Idioma",
                trailing: "Español",
                showChevron: true
            )

            ProfileDarkModeRowView(isDarkMode: $isDarkMode)

            ProfileOptionRowView(
                icon: "trash.fill",
                title: "Eliminar cuenta",
                trailing: nil,
                showChevron: true,
                style: .danger
            )

            ProfileOptionRowView(
                icon: "info.circle.fill",
                title: "Versión",
                trailing: "1.0.0",
                showChevron: false
            )
        }
    }
}
