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

    private var activeMembership: some View {
        VStack(
            spacing: 18
        ) {
            HStack(
                alignment: .top,
                spacing: 12
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {
                    Text(
                        "Paquete o Membresía"
                    )
                    .font(
                        .system(
                            size: 9,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )

                    Text(
                        profile.packageDisplayName
                    )
                    .font(
                        .system(
                            size: 18,
                            weight: .black
                        )
                    )
                    .lineLimit(2)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

                VStack(
                    alignment: .trailing,
                    spacing: 5
                ) {
                    Text("Expiración")
                        .font(
                            .system(
                                size: 9,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            .secondary
                        )

                    Text(
                        profile.packageExpiration
                    )
                    .font(
                        .system(
                            size: 12,
                            weight: .bold
                        )
                    )
                    .multilineTextAlignment(
                        .trailing
                    )

                    Text(
                        profile.classesDescription
                    )
                    .font(
                        .system(
                            size: 12,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )
                }
            }

            VStack(
                spacing: 7
            ) {
                HStack {
                    Text(
                        profile.isMonthlyPackage
                        ? "Uso de Membresía Mensual"
                        : "Progreso de Clases"
                    )

                    Spacer()

                    Text(
                        "\(Int(progress * 100))%"
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )
                }
                .font(
                    .system(
                        size: 9,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    .secondary
                )

                GeometryReader { proxy in
                    ZStack(
                        alignment: .leading
                    ) {
                        Capsule()
                            .fill(
                                Color(
                                    red: 0.15,
                                    green: 0.17,
                                    blue: 0.20
                                )
                            )

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(
                                            red: 0.83,
                                            green: 1.0,
                                            blue: 0.0
                                        ),
                                        Color(
                                            red: 0.0,
                                            green: 1.0,
                                            blue: 0.90
                                        )
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width:
                                    proxy.size.width *
                                    progress
                            )
                    }
                }
                .frame(height: 7)
            }

            HStack {
                Text(
                    "Clases extras:"
                )
                .font(
                    .system(
                        size: 13,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    .secondary
                )

                Spacer()

                Text(
                    "\(profile.extraCredits)"
                )
                .font(
                    .system(
                        size: 13,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }
        }
        .padding(20)
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
    }

    private var emptyMembership: some View {
        VStack(
            spacing: 13
        ) {
            Image(
                systemName: "plus.circle"
            )
            .font(
                .system(
                    size: 30
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "SIN SUSCRIPCIÓN ACTIVA"
            )
            .font(
                .system(
                    size: 11,
                    weight: .black
                )
            )

            Button(
                action: onPurchase
            ) {
                Text(
                    "ADQUIRIR PAQUETE"
                )
                .font(
                    .system(
                        size: 10,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color(
                        "BeastBackground"
                    )
                )
                .padding(
                    .horizontal,
                    20
                )
                .frame(height: 38)
                .background(
                    Capsule()
                        .fill(
                            BeastColors.primary
                        )
                )
            }
            .buttonStyle(.plain)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(22)
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
    }

    private var progress: Double {
        if profile.isMonthlyPackage {
            return monthlyProgress
        }

        return profile.classProgress
    }

    private var monthlyProgress: Double {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )
        formatter.dateFormat = "yyyy-MM-dd"

        guard
            let expirationDate =
                formatter.date(
                    from:
                        String(
                            profile.packageExpiration
                                .prefix(10)
                        )
                )
        else {
            return 0
        }

        let calendar = Calendar.current

        let today = calendar.startOfDay(
            for: Date()
        )

        let expiration =
            calendar.startOfDay(
                for: expirationDate
            )

        guard
            let daysRemaining =
                calendar.dateComponents(
                    [.day],
                    from: today,
                    to: expiration
                ).day
        else {
            return 0
        }

        if daysRemaining <= 0 {
            return 1
        }

        let totalDays = 30.0

        return min(
            max(
                (
                    totalDays -
                    Double(daysRemaining)
                ) /
                totalDays,
                0
            ),
            1
        )
    }
}
