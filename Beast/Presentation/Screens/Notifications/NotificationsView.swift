import SwiftUI

@MainActor
struct NotificationsView: View {
    @StateObject private var viewModel =
        NotificationsViewModel()

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            if viewModel.notifications.isEmpty &&
                !viewModel.isLoading
            {
                emptyState
            } else {
                notificationList
            }

            if viewModel.isLoading {
                BeastLoadingOverlay(
                    message:
                        "Cargando notificaciones..."
                )
                .zIndex(
                    100
                )
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title: "¡Atención!",
                    message:
                        viewModel.errorMessage,
                    buttonTitle:
                        "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(
                    200
                )
            }
        }
        .navigationTitle(
            "Notificaciones"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar {
            ToolbarItem(
                placement:
                    .topBarTrailing
            ) {
                Image(
                    systemName:
                        "bolt.fill"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }
        }
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .task {
            await viewModel.load()
        }
    }

    private var notificationList:
        some View
    {
        ScrollView(
            showsIndicators: false
        ) {
            LazyVStack(
                spacing: 14
            ) {
                ForEach(
                    viewModel.notifications
                ) { notification in
                    NotificationCard(
                        notification:
                            notification
                    )
                }

                Spacer()
                    .frame(
                        height: 32
                    )
            }
            .padding(
                .horizontal,
                20
            )
            .padding(
                .top,
                16
            )
        }
    }

    private var emptyState:
        some View
    {
        VStack(
            spacing: 0
        ) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        BeastColors.surface
                    )

                Image(
                    systemName:
                        "bell.slash.fill"
                )
                .font(
                    .system(
                        size: 30,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
            }
            .frame(
                width: 80,
                height: 80
            )

            Text(
                "Sin notificaciones"
            )
            .font(
                .system(
                    size: 18,
                    weight: .bold
                )
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .padding(
                .top,
                20
            )

            Text(
                "Te avisaremos cuando tengas actualizaciones\no pagos importantes."
            )
            .font(
                .system(
                    size: 13
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(
                .center
            )
            .lineSpacing(
                4
            )
            .padding(
                .top,
                8
            )

            Spacer()
        }
        .frame(
            maxWidth: .infinity
        )
    }
}
