import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @AppStorage("dark_mode")
    private var darkMode = false

    @State private var showEditProfile = false
    @State private var showNotifications = false
    @State private var showResponsiva = false
    @State private var showSignature = false

    var onPackages: () -> Void = {}
    var onChangePassword: (String) -> Void = { _ in }
    var onPolicies: () -> Void = {}

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                LazyVStack(
                    alignment: .leading,
                    spacing: 18
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

                    logoutButton

                    ProfilePoweredByNexus()

                    Spacer()
                        .frame(
                            height: 90
                        )
                }
                .padding(
                    .horizontal,
                    20
                )
                .padding(
                    .top,
                    12
                )
            }
        }
        .navigationTitle(
            "Perfil de Usuario"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
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
            isPresented: $showResponsiva
        ) {
            ResponsivePDFView(
                urlString:
                    viewModel.profile.responsiveURL
            )
        }
        .navigationDestination(
            isPresented: $showSignature
        ) {
            PrivacySignatureView {
                viewModel.onAppear()
            }
        }
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    showNotifications = true
                } label: {
                    Image(
                        systemName: "bell.fill"
                    )
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )
                }
                .buttonStyle(
                    .plain
                )
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    private var subscriptionSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle(
                "Tu Suscripción"
            )

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
            sectionTitle(
                "Información"
            )

            ProfileMenuCard {
                ProfileMenuRow(
                    icon: "shield.fill",
                    title: "Políticas e Información"
                ) {
                    onPolicies()
                }

                if !viewModel.profile.responsiveURL.isEmpty {
                    Divider()
                        .padding(
                            .leading,
                            54
                        )

                    ProfileMenuRow(
                        icon: "doc.text.fill",
                        title: "Responsiva"
                    ) {
                        openResponsiva()
                    }
                }
            }
        }
    }

    private var configurationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            sectionTitle(
                "Configuración"
            )

            ProfileMenuCard {
                ProfileMenuRow(
                    icon: "globe",
                    title: "Lenguaje",
                    value: "Español (MX)"
                ) {}

                Divider()
                    .padding(
                        .leading,
                        54
                    )

                ProfileMenuToggleRow(
                    icon: "moon.fill",
                    title: "Modo Oscuro",
                    isOn: $darkMode
                )

                Divider()
                    .padding(
                        .leading,
                        54
                    )

                ProfileMenuRow(
                    icon: "lock.fill",
                    title: "Cambiar contraseña"
                ) {
                    onChangePassword(
                        viewModel.profile.email
                    )
                }
            }
        }
    }

    private var logoutButton: some View {
        Button {
            viewModel.requestLogout()
        } label: {
            Text(
                "CERRAR SESIÓN"
            )
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
            .frame(
                height: 52
            )
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
        .buttonStyle(
            .plain
        )
        .padding(
            .top,
            2
        )
    }

    private func sectionTitle(
        _ title: String
    ) -> some View {
        Text(
            title
        )
        .font(
            .system(
                size: 13,
                weight: .bold
            )
        )
        .foregroundStyle(
            BeastColors.textSecondary
        )
        .padding(
            .leading,
            6
        )
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
