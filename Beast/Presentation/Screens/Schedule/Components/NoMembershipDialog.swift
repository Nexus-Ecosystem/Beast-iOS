import SwiftUI

struct NoMembershipDialog: View {
    let onDismiss: () -> Void
    let onGoToPackages: () -> Void
    let onContactSupport: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.72)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                BeastColors.textPrimary
                            )
                            .frame(
                                width: 40,
                                height: 40
                            )
                    }
                    .buttonStyle(.plain)
                }

                ZStack {
                    Circle()
                        .fill(
                            BeastColors.background
                        )
                        .frame(
                            width: 78,
                            height: 78
                        )

                    Image(
                        systemName: "lock.fill"
                    )
                    .font(
                        .system(
                            size: 34,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )
                }
                .padding(.top, 2)

                Text(
                    "SIN MEMBRESÍA\nACTIVA"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .multilineTextAlignment(.center)
                .lineSpacing(1)
                .padding(.top, 20)

                Text(
                    "Parece que no tienes un paquete o mensualidad activa en este momento. Para continuar, puedes adquirir un plan desde la sección de paquetes o contactar a administración."
                )
                .font(
                    .system(
                        size: 13,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 8)
                .padding(.top, 14)

                Button {
                    onGoToPackages()
                } label: {
                    HStack(spacing: 10) {
                        Image(
                            systemName: "cart.fill"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .bold
                            )
                        )

                        Text(
                            "IR A PAQUETES"
                        )
                        .font(
                            .system(
                                size: 13,
                                weight: .black
                            )
                        )
                    }
                    .foregroundStyle(
                        BeastColors.background
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 52
                    )
                    .background(
                        BeastColors.primary
                    )
                    .clipShape(
                        Capsule()
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 28)

                Button {
                    onContactSupport()
                } label: {
                    HStack(spacing: 10) {
                        Image(
                            systemName: "message.fill"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .bold
                            )
                        )

                        Text(
                            "CONTACTAR ADMINISTRACIÓN"
                        )
                        .font(
                            .system(
                                size: 12,
                                weight: .black
                            )
                        )
                    }
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 52
                    )
                    .overlay {
                        Capsule()
                            .stroke(
                                BeastColors.textSecondary
                                    .opacity(0.35),
                                lineWidth: 1
                            )
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .frame(maxWidth: 340)
            .background(
                BeastColors.surface
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
            )
            .padding(.horizontal, 28)
            .shadow(
                color: .black.opacity(0.25),
                radius: 30,
                x: 0,
                y: 16
            )
        }
    }
}
