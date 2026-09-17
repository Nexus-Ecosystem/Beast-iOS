import SwiftUI
import UIKit

struct MainTabView: View {
    @State
    private var selectedTab: MainTab = .home

    @Environment(\.colorScheme)
    private var colorScheme

    @StateObject
    private var scheduleViewModel =
        ScheduleViewModel()

    @StateObject
    private var profileViewModel =
        ProfileViewModel()

    @StateObject
    private var packagesViewModel =
        PackagesViewModel()

    @State
    private var bikeSelectionContext:
        BikeSelectionContext?

    @State
    private var showBikeSelection = false

    // MARK: - Responsiva

    @State
    private var showSignature = false

    @State
    private var hasValidatedResponsive = false

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea()

            TabView(
                selection: $selectedTab
            ) {
                homeTab
                scheduleTab
                packagesTab
                profileTab
            }
            .tint(
                Color("BeastTabSelected")
            )

            globalOverlays
        }
        .animation(
            .easeInOut(duration: 0.2),
            value:
                scheduleViewModel
                    .showNoMembership
        )
        .fullScreenCover(
            isPresented: $showSignature
        ) {
            NavigationStack {
                PrivacySignatureView {
                    signatureCompleted()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .task {
            configureTabBar()

            profileViewModel.onAppear()

            await packagesViewModel.load()
        }
        .onChange(
            of: profileViewModel.isLoading
        ) { _, isLoading in
            guard !isLoading else {
                return
            }

            validateResponsiveIfNeeded()

            Task {
                await packagesViewModel.refresh()
            }
        }
        .onChange(
            of:
                profileViewModel
                    .profile
                    .responsiveSigned
        ) { _, signed in
            responsiveSignedChanged(
                signed
            )
        }
        .onChange(
            of: selectedTab
        ) { _, tab in
            guard tab == .packages else {
                return
            }

            Task {
                await packagesViewModel.refresh()
            }
        }
        .onChange(
            of: colorScheme
        ) { _, _ in
            configureTabBar()
        }
    }

    // MARK: - Home

    private var homeTab: some View {
        NavigationStack {
            HomeView()
        }
        .tabItem {
            Image(
                systemName:
                    MainTab.home.icon
            )
        }
        .tag(MainTab.home)
    }

    // MARK: - Schedule

    private var scheduleTab: some View {
        NavigationStack {
            ScheduleView(
                viewModel:
                    scheduleViewModel,
                onSelectBike: {
                    item,
                    day,
                    month in

                    openBikeSelection(
                        item: item,
                        day: day,
                        month: month
                    )
                }
            )
            .navigationDestination(
                isPresented:
                    $showBikeSelection
            ) {
                if let context =
                    bikeSelectionContext {
                    BikeSelectionView(
                        context: context,
                        viewModel:
                            BikeSelectionViewModel()
                    )
                }
            }
        }
        .tabItem {
            Image(
                systemName:
                    MainTab.schedule.icon
            )
        }
        .tag(MainTab.schedule)
    }

    // MARK: - Packages

    private var packagesTab: some View {
        NavigationStack {
            PackagesView(
                viewModel:
                    packagesViewModel
            )
        }
        .tabItem {
            Image(
                systemName:
                    MainTab.packages.icon
            )
        }
        .tag(MainTab.packages)
    }

    // MARK: - Profile

    private var profileTab: some View {
        NavigationStack {
            ProfileView(
                viewModel:
                    profileViewModel,
                onPackages: {
                    selectedTab =
                        .packages
                }
            )
        }
        .tabItem {
            Image(
                systemName:
                    MainTab.profile.icon
            )
        }
        .tag(MainTab.profile)
    }

    // MARK: - Global Overlays

    @ViewBuilder
    private var globalOverlays: some View {
        scheduleOverlays
        profileOverlays
    }

    // MARK: - Profile Overlays

    @ViewBuilder
    private var profileOverlays: some View {
        if profileViewModel.isLoading {
            BeastLoadingOverlay(
                message:
                    "Actualizando perfil..."
            )
            .zIndex(4000)
        }

        if profileViewModel
            .showLogoutConfirmation {
            BeastLogoutDialog(
                onConfirm: {
                    profileViewModel
                        .confirmLogout()
                },
                onCancel: {
                    profileViewModel
                        .cancelLogout()
                }
            )
            .zIndex(5000)
        }

        if let error =
            profileViewModel.errorMessage {
            BeastAlertDialog(
                style: .error,
                title: "¡Atención!",
                message: error,
                buttonTitle: "Entendido"
            ) {
                profileViewModel
                    .resetError()
            }
            .zIndex(6000)
        }
    }

    // MARK: - Schedule Overlays

    @ViewBuilder
    private var scheduleOverlays: some View {
        if
            scheduleViewModel
                .showBookingConfirmation,
            let item =
                scheduleViewModel
                    .selectedClass
        {
            ScheduleBookingConfirmationDialog(
                item: item,
                date:
                    scheduleViewModel
                        .selectedDate,
                title:
                    "CONFIRMAR RESERVA",
                message:
                    "Asegura tu lugar confirmando esta reserva, no te quedes sin tu lugar !.",
                confirmTitle:
                    "CONFIRMAR",
                onConfirm: {
                    scheduleViewModel
                        .confirmBooking()
                },
                onClose: {
                    scheduleViewModel
                        .closeConfirmation()
                }
            )
            .zIndex(1000)
        }

        if
            scheduleViewModel
                .showExtraBookingConfirmation,
            let item =
                scheduleViewModel
                    .selectedClass
        {
            ScheduleBookingConfirmationDialog(
                item: item,
                date:
                    scheduleViewModel
                        .selectedDate,
                title:
                    "RESERVA EXTRA",
                message:
                    "Ya tienes una clase agendada este día. Esta reserva se tomará como una clase extra.",
                confirmTitle:
                    "CONFIRMAR",
                onConfirm: {
                    scheduleViewModel
                        .confirmExtraBooking()
                },
                onClose: {
                    scheduleViewModel
                        .closeConfirmation()
                }
            )
            .zIndex(1000)
        }

        if
            scheduleViewModel
                .showCancellationConfirmation,
            let item =
                scheduleViewModel
                    .selectedClass
        {
            ScheduleBookingConfirmationDialog(
                item: item,
                date:
                    scheduleViewModel
                        .selectedDate,
                title:
                    "CANCELAR RESERVA",
                message:
                    "¿Estás seguro de que deseas cancelar tu reserva?",
                confirmTitle:
                    "CANCELAR RESERVA",
                destructive: true,
                onConfirm: {
                    scheduleViewModel
                        .confirmCancellation()
                },
                onClose: {
                    scheduleViewModel
                        .closeConfirmation()
                }
            )
            .zIndex(1000)
        }

        if scheduleViewModel
            .showNoMembership {
            NoMembershipDialog(
                onDismiss: {
                    scheduleViewModel
                        .closeNoMembership()
                },
                onGoToPackages: {
                    scheduleViewModel
                        .closeNoMembership()

                    selectedTab =
                        .packages
                },
                onContactSupport: {
                    scheduleViewModel
                        .closeNoMembership()

                    openMembershipWhatsApp()
                }
            )
            .zIndex(1500)
        }

        if scheduleViewModel
            .isBookingLoading {
            BeastLoadingOverlay(
                message:
                    "Procesando reserva..."
            )
            .zIndex(2000)
        }

        if scheduleViewModel
            .showBookingSuccess {
            BeastAlertDialog(
                style: .success,
                title: "¡Felicidades!",
                message:
                    scheduleViewModel
                        .bookingMessage,
                buttonTitle: "Entendido"
            ) {
                scheduleViewModel
                    .closeSuccess()
            }
            .zIndex(3000)
        }

        if scheduleViewModel
            .showBookingError {
            BeastAlertDialog(
                style: .error,
                title: "¡Atención!",
                message:
                    scheduleViewModel
                        .bookingMessage,
                buttonTitle: "Entendido"
            ) {
                scheduleViewModel
                    .closeError()
            }
            .zIndex(3000)
        }
    }

    // MARK: - Responsiva

    private func validateResponsiveIfNeeded() {
        guard !hasValidatedResponsive else {
            return
        }

        guard !profileViewModel.isLoading else {
            return
        }

        guard
            !profileViewModel
                .profile
                .email
                .isEmpty
        else {
            return
        }

        hasValidatedResponsive = true

        showSignature =
            !profileViewModel
                .profile
                .responsiveSigned
    }

    private func responsiveSignedChanged(
        _ signed: Bool
    ) {
        guard hasValidatedResponsive else {
            return
        }

        if signed {
            showSignature = false
        }
    }

    private func signatureCompleted() {
        showSignature = false

        Task {
            await profileViewModel.refresh()

            await packagesViewModel.refresh()
        }
    }

    // MARK: - Bike Selection

    private func openBikeSelection(
        item: ClassItem,
        day: String,
        month: String
    ) {
        bikeSelectionContext =
            BikeSelectionContext(
                classItem: item,
                day: day,
                month: month
            )

        showBikeSelection = true
    }

    // MARK: - Membership

    private func openMembershipWhatsApp() {
        let phoneNumber =
            "523323542375"

        let message =
            "¡Hola! Me gustaría renovar o adquirir una membresía/paquete."

        guard
            let encodedMessage =
                message.addingPercentEncoding(
                    withAllowedCharacters:
                        .urlQueryAllowed
                ),
            let url = URL(
                string:
                    "https://wa.me/\(phoneNumber)?text=\(encodedMessage)"
            )
        else {
            return
        }

        UIApplication.shared.open(url)
    }

    // MARK: - Tab Bar

    private func configureTabBar() {
        let appearance =
            UITabBarAppearance()

        appearance
            .configureWithTransparentBackground()

        appearance.backgroundEffect =
            UIBlurEffect(
                style:
                    .systemUltraThinMaterial
            )

        appearance.backgroundColor =
            UIColor(
                Color(
                    "BeastTabBackground"
                )
            )
            .withAlphaComponent(0.94)

        appearance.shadowColor =
            UIColor.black
                .withAlphaComponent(0.05)

        let itemAppearance =
            UITabBarItemAppearance()

        itemAppearance.normal.iconColor =
            UIColor(
                Color(
                    "BeastTabUnselected"
                )
            )

        itemAppearance
            .normal
            .titleTextAttributes = [
                .foregroundColor:
                    UIColor.clear,
                .font:
                    UIFont.systemFont(
                        ofSize: 1
                    )
            ]

        itemAppearance
            .normal
            .titlePositionAdjustment =
            UIOffset(
                horizontal: 0,
                vertical: 100
            )

        itemAppearance.selected.iconColor =
            UIColor(
                Color(
                    "BeastTabSelected"
                )
            )

        itemAppearance
            .selected
            .titleTextAttributes = [
                .foregroundColor:
                    UIColor.clear,
                .font:
                    UIFont.systemFont(
                        ofSize: 1
                    )
            ]

        itemAppearance
            .selected
            .titlePositionAdjustment =
            UIOffset(
                horizontal: 0,
                vertical: 100
            )

        appearance.stackedLayoutAppearance =
            itemAppearance

        appearance.inlineLayoutAppearance =
            itemAppearance

        appearance
            .compactInlineLayoutAppearance =
            itemAppearance

        UITabBar
            .appearance()
            .standardAppearance =
            appearance

        UITabBar
            .appearance()
            .scrollEdgeAppearance =
            appearance

        UITabBar
            .appearance()
            .isTranslucent = true

        UITabBar
            .appearance()
            .itemPositioning = .fill
    }
}
