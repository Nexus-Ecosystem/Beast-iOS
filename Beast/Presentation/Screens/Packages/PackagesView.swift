import SwiftUI

struct PackagesView: View {
    @ObservedObject var viewModel: PackagesViewModel

    let onDetailRequested: (PaqueteMemberShipModel) -> Void
    let onPurchaseRequested: (PaqueteMemberShipModel) -> Void

    init(
        viewModel: PackagesViewModel,
        onDetailRequested: @escaping (PaqueteMemberShipModel) -> Void,
        onPurchaseRequested: @escaping (PaqueteMemberShipModel) -> Void
    ) {
        self.viewModel = viewModel
        self.onDetailRequested = onDetailRequested
        self.onPurchaseRequested = onPurchaseRequested
    }

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            mainContent
            overlays
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var mainContent: some View {
        if viewModel.shouldShowEmptyState {
            emptyState
        } else {
            packagesContent
        }
    }

    private var packagesContent: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(
                alignment: .leading,
                spacing: 22
            ) {
                header

                if let featured =
                    viewModel.featuredPackage {
                    featuredCard(
                        featured
                    )
                }

                if !viewModel.otherPackages.isEmpty {
                    otherPackagesSection
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            Text("SUSCRIPCIONES Y PAQUETES")
                .font(
                    .system(
                        size: 27,
                        weight: .black
                    )
                )
                .italic()

            Text(
                "Encuentra el plan que mejor se adapte a tu entrenamiento."
            )
            .font(
                .system(
                    size: 12,
                    weight: .medium
                )
            )
            .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: - Featured

    private func featuredCard(
        _ package: PaqueteMemberShipModel
    ) -> some View {
        FeaturedMembershipCard(
            package: package,
            isActive:
                viewModel.isActive(package),
            buttonTitle:
                viewModel.actionTitle(
                    for: package
                ),
            canBuy:
                viewModel.canBuy(package)
        ) {
            requestPurchase(package)
        }
    }

    // MARK: - Other Packages

    private var otherPackagesSection: some View {
        VStack(
            alignment: .leading,
            spacing: 13
        ) {
            Text("MÁS OPCIONES")
                .font(
                    .system(
                        size: 13,
                        weight: .black
                    )
                )
                .tracking(1)

            LazyVGrid(
                columns: [
                    GridItem(
                        .flexible(),
                        spacing: 12
                    ),
                    GridItem(
                        .flexible(),
                        spacing: 12
                    )
                ],
                spacing: 12
            ) {
                ForEach(
                    viewModel.otherPackages
                ) { package in
                    SpecialPackageCard(
                        package: package,
                        isActive:
                            viewModel.isActive(
                                package
                            ),
                        buttonTitle:
                            viewModel.actionTitle(
                                for: package
                            ),
                        canBuy:
                            viewModel.canBuy(
                                package
                            ),
                        onDetail: {
                            onDetailRequested(
                                package
                            )
                        },
                        onBuy: {
                            requestPurchase(
                                package
                            )
                        }
                    )
                }
            }
        }
    }

    // MARK: - Empty

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(
                systemName: "rectangle.stack"
            )
            .font(
                .system(
                    size: 40,
                    weight: .medium
                )
            )
            .foregroundStyle(.secondary)

            Text(
                "NO HAY PAQUETES DISPONIBLES"
            )
            .font(
                .system(
                    size: 16,
                    weight: .black
                )
            )
            .italic()
            .multilineTextAlignment(.center)

            Text(
                "Cuando existan paquetes disponibles para tu sucursal aparecerán aquí."
            )
            .font(
                .system(
                    size: 12,
                    weight: .medium
                )
            )
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 35)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    // MARK: - Actions

    private func requestPurchase(
        _ package: PaqueteMemberShipModel
    ) {
        guard viewModel.canBuy(package) else {
            return
        }

        onPurchaseRequested(package)
    }

    // MARK: - Overlays

    @ViewBuilder
    private var overlays: some View {
        if viewModel.isLoading {
            BeastLoadingOverlay(
                message: "Cargando paquetes..."
            )
            .zIndex(100)
        }

        if let error =
            viewModel.errorMessage {
            BeastAlertDialog(
                style: .error,
                title: "¡Atención!",
                message: error,
                buttonTitle: "Entendido"
            ) {
                viewModel.resetError()
            }
            .zIndex(200)
        }
    }
}
