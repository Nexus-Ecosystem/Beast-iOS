import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    @AppStorage("dark_mode")
    private var darkMode = false

    var onEditProfile: () -> Void = {}
    var onNotifications: () -> Void = {}
    var onPackages: () -> Void = {}
    var onChangePassword: (String) -> Void = { _ in }
    var onPolicies: () -> Void = {}
    var onResponsiva: (String) -> Void = { _ in }

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                LazyVStack(
                    alignment: .leading,
                    spacing: 18
                ) {
                    ProfileHeaderCard(
                        profile: viewModel.profile,
                        onTap: onEditProfile
                    )

                    subscriptionSection

                    informationSection

                    configurationSection

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
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    onNotifications()
                } label: {
                    Image(systemName: "bell.fill")
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
                .buttonStyle(.plain)
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
                        .padding(.leading, 54)

                    ProfileMenuRow(
                        icon: "doc.text.fill",
                        title: "Responsiva"
                    ) {
                        onResponsiva(
                            viewModel.profile.responsiveURL
                        )
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
                    .padding(.leading, 54)

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
            Text("CERRAR SESIÓN")
                .font(
                    .system(
                        size: 12,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.90,
                        green: 0.32,
                        blue: 0.32
                    )
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
                        Color(
                            .secondarySystemBackground
                        )
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
                .secondary
            )
            .padding(.leading, 6)
    }
}
