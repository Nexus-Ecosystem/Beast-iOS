import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var scheduleViewModel =
        ScheduleViewModel()

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea(.all)

            TabView(
                selection: $selectedTab
            ) {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Image(
                        systemName:
                            MainTab.home.icon
                    )
                }
                .tag(
                    MainTab.home
                )

                NavigationStack {
                    ScheduleView(
                        viewModel:
                            scheduleViewModel,
                        onSelectBike: {
                            item,
                            day,
                            month in

                            print(
                                "Seleccionar bici"
                            )

                            print(
                                "Clase: \(item.id)"
                            )

                            print(
                                "Día: \(day)"
                            )

                            print(
                                "Mes: \(month)"
                            )
                        }
                    )
                }
                .tabItem {
                    Image(
                        systemName:
                            MainTab.schedule.icon
                    )
                }
                .tag(
                    MainTab.schedule
                )

                NavigationStack {
                    PackagesView()
                }
                .tabItem {
                    Image(
                        systemName:
                            MainTab.packages.icon
                    )
                }
                .tag(
                    MainTab.packages
                )

                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Image(
                        systemName:
                            MainTab.profile.icon
                    )
                }
                .tag(
                    MainTab.profile
                )
            }
            .tint(
                Color(
                    "BeastTabSelected"
                )
            )

            scheduleDialogs
        }
        .ignoresSafeArea(
            .keyboard
        )
        .onAppear {
            configureTabBar()
        }
        .onChange(
            of: colorScheme
        ) { _, _ in
            configureTabBar()
        }
    }

    @ViewBuilder
    private var scheduleDialogs: some View {
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
            .zIndex(100)
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
            .zIndex(100)
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
            .zIndex(100)
        }

        if scheduleViewModel
            .isBookingLoading
        {
            BeastLoadingOverlay(
                message:
                    "Procesando reserva..."
            )
            .zIndex(200)
        }

        if scheduleViewModel
            .showBookingSuccess
        {
            BeastAlertDialog(
                style: .success,
                title: "¡Felicidades!",
                message:
                    scheduleViewModel
                    .bookingMessage,
                buttonTitle:
                    "Entendido"
            ) {
                scheduleViewModel
                    .closeSuccess()
            }
            .zIndex(300)
        }

        if scheduleViewModel
            .showBookingError
        {
            BeastAlertDialog(
                style: .error,
                title: "¡Atención!",
                message:
                    scheduleViewModel
                    .bookingMessage,
                buttonTitle:
                    "Entendido"
            ) {
                scheduleViewModel
                    .closeError()
            }
            .zIndex(300)
        }
    }

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
            .withAlphaComponent(
                0.94
            )

        appearance.shadowColor =
            UIColor.black
            .withAlphaComponent(
                0.05
            )

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

        appearance.compactInlineLayoutAppearance =
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
            .isTranslucent =
            true

        UITabBar
            .appearance()
            .itemPositioning =
            .fill
    }
}
