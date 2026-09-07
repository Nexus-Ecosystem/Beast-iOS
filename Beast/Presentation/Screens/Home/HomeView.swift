import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedReservationPage = 0

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                LazyVStack(
                    spacing: 0
                ) {
                    header

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
                        .frame(
                            height: 120
                        )
                }
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    NavigationLink {
                        QrCheckInView()
                    } label: {
                        Image(
                            systemName: "qrcode"
                        )
                        .font(
                            .system(
                                size: 23,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            Color.black
                        )
                        .frame(
                            width: 58,
                            height: 58
                        )
                        .background(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                            .fill(
                                BeastColors.yellowPrimary
                            )
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(
                        .trailing,
                        24
                    )
                    .padding(
                        .bottom,
                        20
                    )
                }
            }

            if viewModel.isLoading {
                BeastLoadingOverlay()
            }
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    private var header: some View {
        HStack {
            Text(formattedDate)
                .font(
                    .system(
                        size: 22,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(
                    BeastColors.primary
                )

            Spacer()
        }
        .padding(
            .horizontal,
            24
        )
        .padding(
            .top,
            16
        )
        .padding(
            .bottom,
            10
        )
    }

    private var upcomingClassesSection: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text("Clases Agendadas")
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        BeastColors.primary
                    )

                HStack(
                    alignment: .bottom
                ) {
                    Text("Próximas")
                        .font(
                            .system(
                                size: 30,
                                weight: .black
                            )
                        )
                        .italic()
                        .foregroundStyle(
                            BeastColors.textPrimary
                        )

                    Spacer()

                    Text(
                        "\(viewModel.upcomingClasses.count) \(viewModel.upcomingClasses.count == 1 ? "clase hoy" : "clases hoy")"
                    )
                    .font(
                        .system(
                            size: 11
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .padding(
                        .bottom,
                        5
                    )
                }
            }
            .padding(
                .horizontal,
                24
            )

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
                    .padding(
                        .horizontal,
                        24
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(
                .page(
                    indexDisplayMode: .never
                )
            )
            .frame(
                height: 285
            )
            .padding(
                .top,
                12
            )

            if viewModel.upcomingClasses.count > 1 {
                HStack(
                    spacing: 8
                ) {
                    ForEach(
                        viewModel.upcomingClasses.indices,
                        id: \.self
                    ) { index in
                        Circle()
                            .fill(
                                index == selectedReservationPage
                                ? BeastColors.primary
                                : BeastColors.textSecondary.opacity(
                                    0.25
                                )
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
                .frame(
                    maxWidth: .infinity
                )
                .padding(
                    .top,
                    4
                )
            }
        }
        .padding(
            .top,
            8
        )
    }

    private var noUpcomingClasses: some View {
        VStack(
            spacing: 20
        ) {
            ZStack {
                Circle()
                    .fill(
                        BeastColors.surface
                    )
                    .frame(
                        width: 64,
                        height: 64
                    )

                Image(
                    systemName: "dumbbell.fill"
                )
                .font(
                    .system(
                        size: 28
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }

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

            Text(
                "¿Listo para tu siguiente reto?\nDescubre las clases de cada día y agenda en el horario que más te convenga."
            )
            .font(
                .system(
                    size: 12
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(
                .center
            )
            .lineSpacing(4)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(32)
        .background(
            RoundedRectangle(
                cornerRadius: 28
            )
            .fill(
                BeastColors.surface
            )
        )
        .padding(
            .horizontal,
            24
        )
        .padding(
            .top,
            16
        )
    }

    private var historySection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
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
                .buttonStyle(
                    .plain
                )
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
        .padding(
            .horizontal,
            24
        )
        .padding(
            .top,
            24
        )
    }

    private var noHistorySection: some View {
        VStack(
            spacing: 18
        ) {
            Image(
                systemName: "dumbbell.fill"
            )
            .font(
                .system(
                    size: 28
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "No tienes historial de clases"
            )
            .font(
                .system(
                    size: 16,
                    weight: .black
                )
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )

            Text(
                "Te invitamos a registrar tu primera clase en la sección de AGENDA."
            )
            .font(
                .system(
                    size: 11
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(32)
        .background(
            RoundedRectangle(
                cornerRadius: 28
            )
            .fill(
                BeastColors.surface
            )
        )
        .padding(
            .horizontal,
            24
        )
        .padding(
            .top,
            24
        )
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(
            identifier: "es_MX"
        )
        formatter.dateFormat =
            "d 'de' MMMM 'del' yyyy"

        return formatter.string(
            from: Date()
        )
    }
}
