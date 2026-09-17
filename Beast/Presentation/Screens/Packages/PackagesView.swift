import SwiftUI

struct PackagesView: View {

    @ObservedObject
    var viewModel: PackagesViewModel

    private let columns = [
        GridItem(
            .flexible(),
            spacing: 12
        ),
        GridItem(
            .flexible(),
            spacing: 12
        )
    ]

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {
                    header

                    content
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }

            overlays
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .fullScreenCover(
            isPresented:
                $viewModel.showPurchaseConfirmation
        ) {
            purchaseConfirmation
        }
    }

    // MARK: - Header

    private var header: some View {
        Text("Suscripciones y paquetes")
            .font(
                .system(
                    size: 26,
                    weight: .black
                )
            )
            .italic()
            .foregroundStyle(.primary)
            .padding(.top, 8)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.shouldShowEmptyState {
            emptyState
        } else {
            packagesContent
        }
    }

    // MARK: - Packages

    @ViewBuilder
    private var packagesContent: some View {
        if let package =
            viewModel.featuredPackage {
            FeaturedMembershipCard(
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
                    )
            ) {
                viewModel.selectPackage(
                    package
                )
            }
        }

        if !viewModel.otherPackages.isEmpty {
            Text("Otras opciones")
                .font(
                    .system(
                        size: 22,
                        weight: .black
                    )
                )
                .foregroundStyle(.primary)
                .padding(.top, 2)

            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 14
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
                            )
                    ) {
                        viewModel.selectPackage(
                            package
                        )
                    }
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 40)

            ZStack {
                Circle()
                    .fill(
                        Color("BeastTabSelected")
                            .opacity(0.12)
                    )
                    .frame(
                        width: 76,
                        height: 76
                    )

                Image(
                    systemName:
                        "rectangle.stack.badge.plus"
                )
                .font(
                    .system(
                        size: 28,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color("BeastTabSelected")
                )
            }

            Text("No hay paquetes disponibles")
                .font(
                    .system(
                        size: 18,
                        weight: .bold
                    )
                )
                .foregroundStyle(.primary)

            Text(
                "No encontramos suscripciones o paquetes disponibles para tu studio."
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium
                )
            )
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .lineSpacing(3)

            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(
                        systemName:
                            "arrow.clockwise"
                    )

                    Text("VOLVER A INTENTAR")
                }
                .font(
                    .system(
                        size: 12,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    Color("BeastTabSelected")
                )
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
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

    // MARK: - Purchase

    @ViewBuilder
    private var purchaseConfirmation: some View {
        if let package =
            viewModel.selectedPackage {
            PurchaseConfirmationView(
                package: package,
                userName:
                    viewModel.userName,
                phone:
                    viewModel.profile?.phone ?? "",
                onDismiss: {
                    viewModel
                        .dismissPurchaseConfirmation()
                }
            )
        }
    }
}

#Preview {
    PackagesView(
        viewModel: PackagesViewModel()
    )
}
