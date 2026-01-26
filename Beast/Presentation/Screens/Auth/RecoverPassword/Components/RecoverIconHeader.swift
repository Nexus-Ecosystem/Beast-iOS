import SwiftUI

struct RecoverIconHeader: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("BeastSurface").opacity(0.85))
                .frame(width: 78, height: 78)
                .overlay(Circle().stroke(Color("BeastBorder"), lineWidth: 1))

            Image(systemName: "lock")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color("BeastYellowPrimary"))

            // Badge (puntito verde)
            Circle()
                .fill(Color.green)
                .frame(width: 10, height: 10)
                .overlay(Circle().stroke(Color("BeastBackground"), lineWidth: 2))
                .offset(x: 26, y: -26)
        }
    }
}
