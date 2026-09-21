import SwiftUI
import UIKit

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var scheduleViewModel = ScheduleViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var packagesViewModel = PackagesViewModel()

    @State private var bikeSelectionContext: BikeSelectionContext?
    @State private var showBikeSelection = false
    @State private var showSignature = false
    @State private var hasValidatedResponsive = false

    @State private var detailPackage: PaqueteMemberShipModel?
    @State private var purchasePackage: PaqueteMemberShipModel?

    private var hasPackageModal: Bool {
        detailPackage != nil || purchasePackage != nil
    }

    var body: some View {
        ZStack {
            Color("BeastBackground").ignoresSafeArea()

            TabView(selection: $selectedTab) {
                homeTab
                scheduleTab
                packagesTab
                profileTab
            }
            .tint(Color("BeastTabSelected"))
            .blur(radius: hasPackageModal ? 5 : 0)
            .allowsHitTesting(!hasPackageModal)

            globalOverlays
                .blur(radius: hasPackageModal ? 5 : 0)
                .allowsHitTesting(!hasPackageModal)

            packageModalBackdrop
            detailOverlay
            purchaseOverlay
        }
        .animation(.easeInOut(duration: 0.2), value: scheduleViewModel.showNoMembership)
        .animation(.easeInOut(duration: 0.2), value: hasPackageModal)
        .fullScreenCover(isPresented: $showSignature) {
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
        .onChange(of: profileViewModel.isLoading) { _, isLoading in
            guard !isLoading else { return }

            validateResponsiveIfNeeded()

            Task {
                await packagesViewModel.refresh()
            }
        }
        .onChange(of: profileViewModel.profile.responsiveSigned) { _, signed in
            responsiveSignedChanged(signed)
        }
        .onChange(of: selectedTab) { _, tab in
            guard tab == .packages else { return }

            Task {
                await packagesViewModel.refresh()
            }
        }
        .onChange(of: colorScheme) { _, _ in
            configureTabBar()
        }
    }

    // MARK: - Tabs

    private var homeTab: some View {
        NavigationStack {
            HomeView()
        }
        .tabItem {
            Image(systemName: MainTab.home.icon)
        }
        .tag(MainTab.home)
    }

    private var scheduleTab: some View {
        NavigationStack {
            ScheduleView(
                viewModel: scheduleViewModel,
                onSelectBike: { item, day, month in
                    openBikeSelection(item: item, day: day, month: month)
                }
            )
            .navigationDestination(isPresented: $showBikeSelection) {
                if let context = bikeSelectionContext {
                    BikeSelectionView(
                        context: context,
                        viewModel: BikeSelectionViewModel()
                    )
                }
            }
        }
        .tabItem {
            Image(systemName: MainTab.schedule.icon)
        }
        .tag(MainTab.schedule)
    }

    private var packagesTab: some View {
        NavigationStack {
            PackagesView(
                viewModel: packagesViewModel,
                onDetailRequested: showDetail,
                onPurchaseRequested: showPurchase
            )
        }
        .tabItem {
            Image(systemName: MainTab.packages.icon)
        }
        .tag(MainTab.packages)
    }

    private var profileTab: some View {
        NavigationStack {
            ProfileView(
                viewModel: profileViewModel,
                onPackages: {
                    selectedTab = .packages
                }
            )
        }
        .tabItem {
            Image(systemName: MainTab.profile.icon)
        }
        .tag(MainTab.profile)
    }

    // MARK: - Package Modals

    @ViewBuilder
    private var packageModalBackdrop: some View {
        if hasPackageModal {
            Color.black
                .opacity(0.48)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    closePackageModals()
                }
                .zIndex(9000)
        }
    }

    @ViewBuilder
    private var detailOverlay: some View {
        if let package = detailPackage {
            SpecialPackageDetailDialog(
                package: package,
                canBuy: packagesViewModel.canBuy(package),
                buttonTitle: packagesViewModel.actionTitle(for: package),
                onDismiss: closeDetail,
                onBuy: {
                    purchaseFromDetail(package)
                }
            )
            .padding(.horizontal, 22)
            .padding(.vertical, 30)
            .transition(.scale(scale: 0.94).combined(with: .opacity))
            .zIndex(9001)
        }
    }

    @ViewBuilder
    private var purchaseOverlay: some View {
        if let package = purchasePackage {
            PurchaseConfirmationDialog(
                package: package,
                userName: packagesViewModel.userName,
                userPhone: packagesViewModel.userPhone,
                administrationPhone: packagesViewModel.branchPhone,
                onDismiss: closePurchase
            )
            .padding(.horizontal, 24)
            .transition(.scale(scale: 0.94).combined(with: .opacity))
            .zIndex(9002)
        }
    }

    private func showDetail(_ package: PaqueteMemberShipModel) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) {
            detailPackage = package
        }
    }

    private func closeDetail() {
        withAnimation(.easeOut(duration: 0.18)) {
            detailPackage = nil
        }
    }

    private func showPurchase(_ package: PaqueteMemberShipModel) {
        guard packagesViewModel.canBuy(package) else { return }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) {
            detailPackage = nil
            purchasePackage = package
        }
    }

    private func purchaseFromDetail(_ package: PaqueteMemberShipModel) {
        showPurchase(package)
    }

    private func closePurchase() {
        withAnimation(.easeOut(duration: 0.18)) {
            purchasePackage = nil
        }
    }

    private func closePackageModals() {
        withAnimation(.easeOut(duration: 0.18)) {
            detailPackage = nil
            purchasePackage = nil
        }
    }

    // MARK: - Global Overlays

    @ViewBuilder
    private var globalOverlays: some View {
        scheduleOverlays
        profileOverlays
    }

    @ViewBuilder
    private var profileOverlays: some View {
        if profileViewModel.isLoading {
            BeastLoadingOverlay(message: "Actualizando perfil...")
                .zIndex(4000)
        }

        if profileViewModel.showLogoutConfirmation {
            BeastLogoutDialog(
                onConfirm: {
                    profileViewModel.confirmLogout()
                },
                onCancel: {
                    profileViewModel.cancelLogout()
                }
            )
            .zIndex(5000)
        }

        if let error = profileViewModel.errorMessage {
            BeastAlertDialog(
                style: .error,
                title: "¡Atención!",
                message: error,
                buttonTitle: "Entendido"
            ) {
                profileViewModel.resetError()
            }
            .zIndex(6000)
        }
    }

    @ViewBuilder
    private var scheduleOverlays: some View {
        if scheduleViewModel.showBookingConfirmation,
           let item = scheduleViewModel.selectedClass {
            ScheduleBookingConfirmationDialog(
                item: item,
                date: scheduleViewModel.selectedDate,
                title: "CONFIRMAR RESERVA",
                message: "Asegura tu lugar confirmando esta reserva, no te quedes sin tu lugar !.",
                confirmTitle: "CONFIRMAR",
                onConfirm: {
                    scheduleViewModel.confirmBooking()
                },
                onClose: {
                    scheduleViewModel.closeConfirmation()
                }
            )
            .zIndex(1000)
        }

        if scheduleViewModel.showExtraBookingConfirmation,
           let item = scheduleViewModel.selectedClass {
            ScheduleBookingConfirmationDialog(
                item: item,
                date: scheduleViewModel.selectedDate,
                title: "RESERVA EXTRA",
                message: "Ya tienes una clase agendada este día. Esta reserva se tomará como una clase extra.",
                confirmTitle: "CONFIRMAR",
                onConfirm: {
                    scheduleViewModel.confirmExtraBooking()
                },
                onClose: {
                    scheduleViewModel.closeConfirmation()
                }
            )
            .zIndex(1000)
        }

        if scheduleViewModel.showCancellationConfirmation,
           let item = scheduleViewModel.selectedClass {
            ScheduleBookingConfirmationDialog(
                item: item,
                date: scheduleViewModel.selectedDate,
                title: "CANCELAR RESERVA",
                message: "¿Estás seguro de que deseas cancelar tu reserva?",
                confirmTitle: "CANCELAR RESERVA",
                destructive: true,
                onConfirm: {
                    scheduleViewModel.confirmCancellation()
                },
                onClose: {
                    scheduleViewModel.closeConfirmation()
                }
            )
            .zIndex(1000)
        }

        if scheduleViewModel.showNoMembership {
            NoMembershipDialog(
                onDismiss: {
                    scheduleViewModel.closeNoMembership()
                },
                onGoToPackages: {
                    scheduleViewModel.closeNoMembership()
                    selectedTab = .packages
                },
                onContactSupport: {
                    scheduleViewModel.closeNoMembership()
                    openMembershipWhatsApp()
                }
            )
            .zIndex(1500)
        }

        if scheduleViewModel.isBookingLoading {
            BeastLoadingOverlay(message: "Procesando reserva...")
                .zIndex(2000)
        }

        if scheduleViewModel.showBookingSuccess {
            BeastAlertDialog(
                style: .success,
                title: "¡Felicidades!",
                message: scheduleViewModel.bookingMessage,
                buttonTitle: "Entendido"
            ) {
                scheduleViewModel.closeSuccess()
            }
            .zIndex(3000)
        }

        if scheduleViewModel.showBookingError {
            BeastAlertDialog(
                style: .error,
                title: "¡Atención!",
                message: scheduleViewModel.bookingMessage,
                buttonTitle: "Entendido"
            ) {
                scheduleViewModel.closeError()
            }
            .zIndex(3000)
        }
    }

    // MARK: - Responsiva

    private func validateResponsiveIfNeeded() {
        guard !hasValidatedResponsive,
              !profileViewModel.isLoading,
              !profileViewModel.profile.email.isEmpty else { return }

        hasValidatedResponsive = true
        showSignature = !profileViewModel.profile.responsiveSigned
    }

    private func responsiveSignedChanged(_ signed: Bool) {
        guard hasValidatedResponsive else { return }

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
        bikeSelectionContext = BikeSelectionContext(
            classItem: item,
            day: day,
            month: month
        )

        showBikeSelection = true
    }

    // MARK: - Membership

    private func openMembershipWhatsApp() {
        let phoneNumber = "523323542375"
        let message = "¡Hola! Me gustaría renovar o adquirir una membresía/paquete."

        guard
            let encodedMessage = message.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(
                string: "https://wa.me/\(phoneNumber)?text=\(encodedMessage)"
            )
        else { return }

        UIApplication.shared.open(url)
    }

    // MARK: - Tab Bar

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor(Color("BeastTabBackground")).withAlphaComponent(0.94)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.05)

        let itemAppearance = UITabBarItemAppearance()

        itemAppearance.normal.iconColor = UIColor(Color("BeastTabUnselected"))
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 1)
        ]
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)

        itemAppearance.selected.iconColor = UIColor(Color("BeastTabSelected"))
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 1)
        ]
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().itemPositioning = .fill
    }
}
