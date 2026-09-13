import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @AppStorage("dark_mode")
    private var darkMode = false

    @Environment(\.openURL)
    private var openURL

    @State private var showEditProfile = false
    @State private var showNotifications = false
    @State private var showResponsiva = false
    @State private var showSignature = false
    @State private var showChangePassword = false
    @State private var showDeleteAccount = false

    var onPackages: () -> Void = {}

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(
                    alignment: .leading,
                    spacing: 20
                ) {
                    ProfileHeaderCard(
                        profile: viewModel.profile,
                        onTap: {
                            showEditProfile = true
                        }
                    )

                    subscriptionSection
                    informationSection
                    configurationSection
                    dangerZoneSection
                    logoutButton
                    ProfilePoweredByNexus()

                    Spacer()
                        .frame(height: 90)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Perfil de Usuario")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(
            isPresented: $showEditProfile
        ) {
            EditProfileView()
        }
        .navigationDestination(
            isPresented: $showNotifications
        ) {
            NotificationsView()
        }
        .navigationDestination(
            isPresented: $showChangePassword
        ) {
            ChangePasswordView(
                email: viewModel.profile.email
            )
        }
        .navigationDestination(
            isPresented: $showDeleteAccount
        ) {
            DeleteAccountView(
                email: viewModel.profile.email,
                onAccountDeleted: {
                    viewModel.confirmLogout()
                }
            )
        }
        .navigationDestination(
            isPresented: $showResponsiva
        ) {
            ResponsivePDFView(
                urlString: viewModel.profile.responsiveURL
            )
        }
        .navigationDestination(
            isPresented: $showSignature
        ) {
            PrivacySignatureView {
                showSignature = false
            }
        }
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    showNotifications = true
                } label: {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(BeastColors.primary)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var subscriptionSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle("Tu Suscripción")

            ProfileMembershipCard(
                profile: viewModel.profile,
                onPurchase: onPackages
            )
        }
    }

    private var informationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle("Información")

            ProfileMenuCard {
                ProfileMenuRow(
                    icon: "shield.fill",
                    title: "Políticas e Información"
                ) {
                    openPolicies()
                }

                Divider()
                    .padding(.leading, 54)

                ProfileMenuRow(
                    icon: viewModel.profile.responsiveSigned
                    ? "doc.text.fill"
                    : "signature",
                    title: viewModel.profile.responsiveSigned
                    ? "Responsiva"
                    : "Firmar responsiva"
                ) {
                    openResponsiva()
                }
            }
        }
    }

    private var configurationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle("Configuración")

            ProfileMenuCard {
                ProfileMenuToggleRow(
                    icon: "moon.fill",
                    title: "Modo Oscuro",
                    isOn: $darkMode
                )

                Divider()
                    .padding(.leading, 54)

                ProfileMenuRow(
                    icon: "lock.fill",
                    title: "Cambiar contraseña"
                ) {
                    showChangePassword = true
                }
            }
        }
    }

    private var dangerZoneSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Zona de riesgo")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(
                    BeastColors.danger
                )
                .padding(.leading, 6)

            Button {
                showDeleteAccount = true
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(
                                BeastColors.danger
                                    .opacity(0.12)
                            )
                            .frame(
                                width: 42,
                                height: 42
                            )

                        Image(
                            systemName: "trash.fill"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            BeastColors.danger
                        )
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text("Eliminar cuenta")
                            .font(
                                .system(
                                    size: 15,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(
                                BeastColors.danger
                            )

                        Text(
                            "Esta acción puede eliminar permanentemente tus datos y acceso."
                        )
                        .font(
                            .system(
                                size: 12,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            BeastColors.textSecondary
                        )
                        .multilineTextAlignment(
                            .leading
                        )
                    }

                    Spacer()

                    Image(
                        systemName: "chevron.right"
                    )
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.danger
                            .opacity(0.7)
                    )
                }
                .padding(16)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: 22,
                        style: .continuous
                    )
                    .fill(
                        BeastColors.danger
                            .opacity(0.05)
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 22,
                        style: .continuous
                    )
                    .stroke(
                        BeastColors.danger
                            .opacity(0.22),
                        lineWidth: 1
                    )
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var logoutButton: some View {
        Button {
            viewModel.requestLogout()
        } label: {
            Text("CERRAR SESIÓN")
                .font(
                    .system(
                        size: 12,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    BeastColors.danger
                )
                .frame(
                    maxWidth: .infinity
                )
                .frame(height: 52)
                .background(
                    RoundedRectangle(
                        cornerRadius: 22,
                        style: .continuous
                    )
                    .fill(
                        BeastColors.surface
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 22,
                        style: .continuous
                    )
                    .stroke(
                        BeastColors.border,
                        lineWidth: 1
                    )
                )
        }
        .buttonStyle(.plain)
        .padding(.top, 2)
    }

    private func sectionTitle(
        _ title: String
    ) -> some View {
        Text(title)
            .font(
                .system(
                    size: 13,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .padding(.leading, 6)
    }

    private func openPolicies() {
        guard let url = URL(
            string:
                "https://bookings-spinnings.web.app/aviso-de-privacidad"
        ) else {
            return
        }

        openURL(url)
    }

    private func openResponsiva() {
        if viewModel.profile.responsiveSigned {
            guard !viewModel.profile.responsiveURL.isEmpty else {
                return
            }

            showResponsiva = true
        } else {
            showSignature = true
        }
    }
}
