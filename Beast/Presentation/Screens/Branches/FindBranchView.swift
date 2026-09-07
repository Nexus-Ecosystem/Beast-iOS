import SwiftUI

struct FindBranchView: View {
    @StateObject private var viewModel: FindBranchViewModel

    var onCompleted: () -> Void = {}

    init(
        email: String? = nil,
        onCompleted: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(
            wrappedValue: FindBranchViewModel(
                registrationEmail: email
            )
        )

        self.onCompleted = onCompleted
    }

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
                    header

                    searchBar

                    Text("CERCANÍA")
                        .font(
                            .system(
                                size: 9,
                                weight: .black
                            )
                        )
                        .tracking(1)
                        .foregroundStyle(
                            BeastColors.textSecondary
                        )

                    filters

                    if viewModel.filteredBranches.isEmpty {
                        emptyState
                    } else {
                        ForEach(
                            viewModel.filteredBranches
                        ) { branch in
                            BranchCardView(
                                branch: branch
                            ) {
                                viewModel.select(
                                    branch
                                )
                            }
                        }
                    }

                    Spacer()
                        .frame(height: 30)
                }
                .padding(
                    .horizontal,
                    24
                )
                .padding(
                    .top,
                    20
                )
            }

            if viewModel.showConfirmation,
               let branch = viewModel.selectedBranch {
                ConfirmStudioDialog(
                    branch: branch
                ) {
                    Task {
                        await viewModel.subscribe()
                    }
                } onCancel: {
                    viewModel.cancelSelection()
                }
                .zIndex(20)
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title: "¡Aviso!",
                    message: viewModel.errorMessage,
                    buttonTitle: "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(30)
            }

            if viewModel.isLoading {
                BeastLoadingOverlay(
                    message: "Suscribiendo a tu estudio..."
                )
                .zIndex(40)
            }

            if viewModel.showSubscriptionSuccess {
                BeastAlertDialog(
                    style: .success,
                    title: "¡Felicidades!",
                    message: "Te has suscrito correctamente a tu STUDIO.",
                    buttonTitle: "Entendido"
                ) {
                    viewModel.closeSubscriptionSuccess()
                    onCompleted()
                }
                .zIndex(50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        HStack(
            spacing: 8
        ) {
            Image(
                systemName: "bolt.fill"
            )

            Text(
                "Busca tu estudio"
            )
            .italic()
        }
        .font(
            .system(
                size: 15,
                weight: .black
            )
        )
        .foregroundStyle(
            BeastColors.primary
        )
    }

    private var searchBar: some View {
        HStack(
            spacing: 10
        ) {
            Image(
                systemName: "magnifyingglass"
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )

            TextField(
                "Buscar estudio por nombre...",
                text: $viewModel.query
            )
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .tint(
                BeastColors.primary
            )

            if !viewModel.query.isEmpty {
                Button {
                    viewModel.query = ""
                } label: {
                    Image(
                        systemName: "xmark"
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .font(
            .system(
                size: 13
            )
        )
        .padding(
            .horizontal,
            16
        )
        .frame(
            height: 48
        )
        .background(
            Capsule()
                .fill(
                    BeastColors.surface
                )
        )
    }

    private var filters: some View {
        HStack(
            spacing: 10
        ) {
            filter(
                "Todo",
                selected: true
            )

            filter(
                "< 1 km",
                selected: false
            )

            filter(
                "1 - 3 km",
                selected: false
            )

            filter(
                "3+ km",
                selected: false
            )
        }
    }

    private func filter(
        _ title: String,
        selected: Bool
    ) -> some View {
        Text(title)
            .font(
                .system(
                    size: 10,
                    weight: .bold
                )
            )
            .foregroundStyle(
                selected
                    ? BeastColors.buttonText
                    : BeastColors.textSecondary
            )
            .padding(
                .horizontal,
                15
            )
            .frame(
                height: 36
            )
            .background(
                Capsule()
                    .fill(
                        selected
                            ? BeastColors.primary
                            : BeastColors.surface
                    )
            )
    }

    private var emptyState: some View {
        VStack(
            spacing: 16
        ) {
            Image(
                systemName:
                    "mappin.slash.circle.fill"
            )
            .font(
                .system(
                    size: 64
                )
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "NO SE ENCONTRARON\nSUCURSALES"
            )
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
            .multilineTextAlignment(
                .center
            )

            Text(
                "Intenta ajustar tu búsqueda para ver más opciones."
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
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(
            .vertical,
            70
        )
    }
}
