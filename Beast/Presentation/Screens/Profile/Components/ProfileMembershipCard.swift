import SwiftUI

struct ProfileMembershipCard: View {
    let profile: ProfileDisplayModel
    let onPurchase: () -> Void

    var body: some View {
        if profile.hasActivePackage {
            activeMembership
        } else {
            emptyMembership
        }
    }

    // MARK: - Active Membership

    private var activeMembership: some View {
        VStack(spacing: 0) {
            membershipHeader

            Spacer()
                .frame(height: 24)

            membershipProgress
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // MARK: - Header

    private var membershipHeader: some View {
        VStack(spacing: 4) {
            HStack {
                Text("Paquete o Membresía")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(BeastColors.primary)

                Spacer()

                Text("Expiración")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(BeastColors.textSecondary)
            }

            HStack(alignment: .top, spacing: 12) {
                Text(profile.packageDisplayName)
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(BeastColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                Text(profile.packageExpiration)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(BeastColors.textPrimary)
                    .multilineTextAlignment(.trailing)
                    .frame(
                        maxWidth: 110,
                        alignment: .trailing
                    )
            }
        }
    }

    // MARK: - Progress

    private var membershipProgress: some View {
        VStack(spacing: 8) {
            HStack {
                Text(progressTitle)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(BeastColors.textSecondary)

                Spacer()

                Text(progressDescription)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(BeastColors.primary)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(
                            Color(
                                red: 0.15,
                                green: 0.17,
                                blue: 0.20
                            )
                        )

                    Capsule()
                        .fill(progressGradient)
                        .frame(
                            width: proxy.size.width * progress
                        )
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: - Empty Membership

    private var emptyMembership: some View {
        VStack(spacing: 13) {
            Image(systemName: "plus.circle")
                .font(.system(size: 30))
                .foregroundStyle(BeastColors.primary)

            Text("SIN SUSCRIPCIÓN ACTIVA")
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(BeastColors.textPrimary)

            Button(action: onPurchase) {
                Text("ADQUIRIR PAQUETE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color("BeastBackground"))
                    .padding(.horizontal, 20)
                    .frame(height: 38)
                    .background(
                        Capsule()
                            .fill(BeastColors.primary)
                    )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // MARK: - Progress Logic

    private var progress: Double {
        min(
            max(profile.classProgress, 0),
            1
        )
    }

    private var progressTitle: String {
        profile.isMonthlyPackage
            ? "Uso de Membresía Mensual"
            : "Progreso de Clases"
    }

    private var progressDescription: String {
        "\(formattedClassesDescription) \(Int(progress * 100))%"
    }

    private var formattedClassesDescription: String {
        let value = profile.classesDescription
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else {
            return ""
        }

        if value.hasPrefix("(") && value.hasSuffix(")") {
            return value
        }

        return "(\(value))"
    }

    // MARK: - Progress Style

    private var progressGradient: LinearGradient {
        LinearGradient(
            colors: progressColors,
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var progressColors: [Color] {
        if progress >= 1 && profile.isMonthlyPackage {
            return [
                .red,
                Color(red: 0.55, green: 0, blue: 0)
            ]
        }

        return [
            Color(red: 0.83, green: 1.0, blue: 0.0),
            Color(red: 0.0, green: 1.0, blue: 0.90)
        ]
    }
}
