import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedReservationPage = 0

    private let headerHeight: CGFloat = 68
    private let headerTopSpacing: CGFloat = 8

    var body: some View {
        ZStack(alignment: .top) {
            BeastColors.background
                .ignoresSafeArea()

            content

            floatingHeader

            qrButton

            if viewModel.isLoading {
                BeastLoadingOverlay()
                    .zIndex(100)
            }
        }
        .task {
            await viewModel.load()
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    // MARK: - Main Content

    private var content: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                if viewModel.upcomingClasses.isEmpty {
                    noUpcomingClasses
                } else {
                    upcomingClassesSection
                }

                if viewModel.classHistory.isEmpty {
                    noHistorySection
                } else {
                    historySection
                }

                Spacer()
                    .frame(height: 120)
            }
            // Espacio inicial para que al abrir Home
            // la primera card no quede tapada por el header.
            //
            // Al hacer scroll, este espacio desaparece
            // y el contenido pasa DETRÁS del glass.
            .padding(
                .top,
                headerHeight + headerTopSpacing + 20
            )
        }
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Floating Glass Header

    private var floatingHeader: some View {
        HomeDateHeader(
            branchName: viewModel.branchName
        )
        .padding(.horizontal, 20)
        .padding(.top, headerTopSpacing)
        .zIndex(50)
    }

    // MARK: - Upcoming

    private var upcomingClassesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Clases Agendadas")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(BeastColors.primary)

                HStack(alignment: .bottom) {
                    Text("Próximas")
                        .font(.system(size: 30, weight: .black))
                        .italic()
                        .foregroundStyle(BeastColors.textPrimary)

                    Spacer()

                    Text(upcomingClassesCountText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(BeastColors.textSecondary)
                        .padding(.bottom, 5)
                }
            }
            .padding(.horizontal, 24)

            TabView(
                selection: $selectedReservationPage
            ) {
                ForEach(
                    Array(
                        viewModel.upcomingClasses.enumerated()
                    ),
                    id: \.offset
                ) { index, reservation in
                    UpcomingReservationCard(
                        reservation: reservation
                    )
                    .padding(.horizontal, 24)
                    .tag(index)
                }
            }
            .tabViewStyle(
                .page(indexDisplayMode: .never)
            )
            .frame(height: 285)
            .padding(.top, 12)

            if viewModel.upcomingClasses.count > 1 {
                pageIndicator
            }
        }
        .padding(.top, 18)
    }

    private var upcomingClassesCountText: String {
        let count = viewModel.upcomingClasses.count

        return "\(count) \(count == 1 ? "clase hoy" : "clases hoy")"
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(
                viewModel.upcomingClasses.indices,
                id: \.self
            ) { index in
                Circle()
                    .fill(
                        index == selectedReservationPage
                            ? BeastColors.primary
                            : BeastColors.textSecondary
                                .opacity(0.25)
                    )
                    .frame(
                        width:
                            index == selectedReservationPage
                            ? 8
                            : 6,
                        height:
                            index == selectedReservationPage
                            ? 8
                            : 6
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }

    // MARK: - Empty Upcoming

    private var noUpcomingClasses: some View {
        Button {
            openSchedule()
        } label: {
            VStack(spacing: 0) {
                Image(systemName: "dumbbell.fill")
                    .font(
                        .system(
                            size: 25,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )

                Text("NO HAY PRÓXIMA CLASE")
                    .font(
                        .system(
                            size: 18,
                            weight: .black
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)

                Text("¿Listo para tu siguiente reto?")
                    .font(
                        .system(
                            size: 13,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                Text(
                    """
                    Descubre las clases de cada día y agenda \
                    en el horario que más te convenga.
                    """
                )
                .font(.system(size: 12))
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 16)
                .padding(.top, 3)

                HStack(spacing: 7) {
                    Text("Explora más clases")

                    Image(systemName: "arrow.right")
                }
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
                .padding(.top, 22)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            .background {
                RoundedRectangle(
                    cornerRadius: 28,
                    style: .continuous
                )
                .fill(BeastColors.surface)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .padding(.top, 18)
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("HISTÓRICO")
                    .font(
                        .system(
                            size: 24,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                Spacer()

                NavigationLink {
                    HistoryView()
                } label: {
                    Text("VER TODO")
                        .font(
                            .system(
                                size: 10,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            BeastColors.primary
                        )
                }
                .buttonStyle(.plain)
            }

            ForEach(
                Array(
                    viewModel.classHistory.enumerated()
                ),
                id: \.offset
            ) { _, reservation in
                HistoryReservationCard(
                    reservation: reservation
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 26)
    }

    // MARK: - Empty History

    private var noHistorySection: some View {
        VStack(spacing: 0) {
            Image(systemName: "dumbbell.fill")
                .font(
                    .system(
                        size: 25,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )

            Text("No tienes historial de clases")
                .font(
                    .system(
                        size: 18,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
                .multilineTextAlignment(.center)
                .padding(.top, 18)

            Text(
                """
                Te invitamos a registrar tu primera clase \
                en la sección de AGENDA.
                """
            )
            .font(.system(size: 12))
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .background {
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .fill(BeastColors.surface)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    // MARK: - QR

    private var qrButton: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                NavigationLink {
                    QrCheckInView()
                } label: {
                    Image(systemName: "qrcode")
                        .font(
                            .system(
                                size: 23,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            BeastColors.buttonText
                        )
                        .frame(
                            width: 58,
                            height: 58
                        )
                        .background {
                            RoundedRectangle(
                                cornerRadius: 14,
                                style: .continuous
                            )
                            .fill(
                                BeastColors.yellowPrimary
                            )
                        }
                }
                .buttonStyle(.plain)
                .padding(.trailing, 24)
                .padding(.bottom, 20)
            }
        }
        .zIndex(40)
    }

    // MARK: - Navigation

    private func openSchedule() {
        NotificationCenter.default.post(
            name: .openScheduleTab,
            object: nil
        )
    }
}

extension Notification.Name {
    static let openScheduleTab =
        Notification.Name("openScheduleTab")
}
