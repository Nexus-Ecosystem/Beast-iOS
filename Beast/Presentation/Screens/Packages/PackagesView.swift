import SwiftUI

struct PackagesView: View {

    @StateObject private var viewModel = PackagesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color("BeastBackground")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Suscripciones y paquetes")
                        .font(.system(size: 26, weight: .black))
                        .italic()
                        .foregroundStyle(.primary)
                        .padding(.top, 8)

                    if let package = viewModel.featuredPackage {
                        FeaturedMembershipCard(
                            package: package,
                            isActive: viewModel.isActive(package),
                            buttonTitle: viewModel.actionTitle(for: package),
                            canBuy: viewModel.canBuy(package)
                        ) {
                            viewModel.selectPackage(package)
                        }
                    }

                    if !viewModel.otherPackages.isEmpty {
                        Text("Otras opciones")
                            .font(.system(size: 22, weight: .black))
                            .foregroundStyle(.primary)
                            .padding(.top, 2)

                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 14
                        ) {
                            ForEach(viewModel.otherPackages) { package in
                                SpecialPackageCard(
                                    package: package,
                                    isActive: viewModel.isActive(package),
                                    buttonTitle: viewModel.actionTitle(for: package),
                                    canBuy: viewModel.canBuy(package)
                                ) {
                                    viewModel.selectPackage(package)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }

            if viewModel.isLoading {
                BeastLoadingOverlay()
                    .zIndex(100)
            }
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .fullScreenCover(
            isPresented: $viewModel.showPurchaseConfirmation
        ) {
            if let package = viewModel.selectedPackage {
                PurchaseConfirmationView(
                    package: package,
                    userName: viewModel.userName,
                    phone: viewModel.profile?.phone ?? "",
                    onDismiss: {
                        viewModel.dismissPurchaseConfirmation()
                    }
                )
            }
        }
    }
}
