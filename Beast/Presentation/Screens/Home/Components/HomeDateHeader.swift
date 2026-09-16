import SwiftUI

struct HomeDateHeader: View {
    let branchName: String

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "d 'de' MMMM 'del' yyyy"
        return formatter.string(from: Date())
    }

    var body: some View {
        HStack(spacing: 14) {
            storeIcon

            VStack(alignment: .leading, spacing: 3) {
                branchRow

                Text(formattedDate)
                    .font(.system(size: 12, weight: .bold))
                    .italic()
                    .foregroundStyle(BeastColors.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .frame(height: 68)
        .background {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .fill(.ultraThinMaterial)
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                BeastColors.border.opacity(0.45),
                lineWidth: 0.8
            )
        }
        .shadow(
            color: BeastColors.textPrimary.opacity(0.08),
            radius: 16,
            x: 0,
            y: 8
        )
    }

    private var storeIcon: some View {
        ZStack {
            Circle()
                .fill(.thinMaterial)
                .frame(width: 44, height: 44)

            Image(systemName: "storefront.fill")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(BeastColors.textSecondary)
        }
    }

    private var branchRow: some View {
        HStack(spacing: 5) {
            Text("Sucursal:")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(BeastColors.textSecondary)

            Text(branchName)
                .font(.system(size: 15, weight: .black))
                .italic()
                .foregroundStyle(BeastColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

#Preview {
    ZStack {
        BeastColors.background
            .ignoresSafeArea()

        HomeDateHeader(
            branchName: "BEAST-TESTISAN"
        )
        .padding(.horizontal, 20)
    }
}
