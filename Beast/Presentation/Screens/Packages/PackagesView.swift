import SwiftUI

struct PackagesView: View {
    @StateObject private var viewModel =
        PackagesViewModel()

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                LazyVStack(
                    spacing: 18
                ) {
                    header

                    ForEach(
                        viewModel.packages
                    ) { package in
                        MembershipCard(
                            package: package,
                            isActive:
                                viewModel.isActive(
                                    package
                                ),
                            isExpired:
                                viewModel.isExpired(
                                    package
                                ),
                            isEmpty:
                                viewModel.isPackageEmpty(
                                    package
                                ),
                            actionTitle:
                                viewModel.actionTitle(
                                    for: package
                                ),
                            actionEnabled:
                                viewModel.canBuy(
                                    package
                                ),
                            onBuy: {
                                viewModel.selectPackage(
                                    package
                                )
                            }
                        )
                    }

                    Spacer()
                        .frame(
                            height: 120
                        )
                }
                .padding(
                    .horizontal,
                    24
                )
            }

            if viewModel.isLoading {
                BeastLoadingOverlay()
            }

            if let error =
                viewModel.errorMessage
            {
                BeastAlertDialog(
                    style: .error,
                    message: error
                ) {
                    viewModel.resetError()
                }
                .zIndex(40)
            }
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
            if let package =
                viewModel.selectedPackage
            {
                PurchaseConfirmationView(
                    package: package,
                    userName:
                        viewModel.userName,
                    phone:
                        "523323542375"
                ) {
                    viewModel
                        .dismissPurchaseConfirmation()
                }
                .presentationBackground(
                    .clear
                )
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Paquetes")
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
        }
        .padding(
            .top,
            20
        )
        .padding(
            .bottom,
            6
        )
    }
}

#Preview {
    PackagesView()
}
