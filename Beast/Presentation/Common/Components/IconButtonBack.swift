import SwiftUI

struct IconButtonBack: View {
    let action: () -> Void

        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color("BeastSurface")) // sólido, no material
                        .overlay(
                            Circle().stroke(Color("BeastBorder"), lineWidth: 1)
                        )
                        .frame(width: 40, height: 40)
                        // sombra MUY sutil (o quítala si quieres 0 sombra)
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color("BeastTextPrimary"))
                }
            }
            .contentShape(Circle())
        }
}
