import SwiftUI

struct FeatureChipItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

struct FeatureChipsRow: View {
    let items: [FeatureChipItem]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(items) { item in
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color("BeastSurface"))
                            .frame(width: 42, height: 42)
                            .overlay(
                                Circle().stroke(Color("BeastBorder"), lineWidth: 1)
                            )

                        Image(systemName: item.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color("BeastYellowPrimary"))
                    }

                    Text(item.title)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color("BeastTextSecondary"))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
