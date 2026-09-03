import SwiftUI

struct PackagesView: View {

    private let horizontalPadding: CGFloat = 22
    private let gridSpacing: CGFloat = 16

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let contentWidth = proxy.size.width - (horizontalPadding * 2)
                let cardWidth = (contentWidth - gridSpacing) / 2

                ZStack(alignment: .top) {
                    BeastPackageColors.background
                        .ignoresSafeArea(.all)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            PopularPackageCardView(
                                package: PackageMockData.popularPackage,
                                width: contentWidth
                            )

                            packagesSection(cardWidth: cardWidth)
                        }
                        .padding(.top, 118)
                        .padding(.bottom, 32)
                        .frame(width: contentWidth)
                        .padding(.horizontal, horizontalPadding)
                    }
                    .scrollContentBackground(.hidden)

                    PackagesHeaderView()
                }
                .navigationBarHidden(true)
            }
        }
    }

    private func packagesSection(cardWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Paquetes especiales")
                .font(.system(size: 21, weight: .heavy, design: .rounded))
                .foregroundStyle(BeastPackageColors.textPrimary)

            LazyVGrid(
                columns: [
                    GridItem(.fixed(cardWidth), spacing: gridSpacing),
                    GridItem(.fixed(cardWidth), spacing: gridSpacing)
                ],
                spacing: gridSpacing
            ) {
                ForEach(PackageMockData.specialPackages) { package in
                    SpecialPackageCardView(
                        package: package,
                        width: cardWidth
                    )
                }
            }
        }
        .frame(width: (cardWidth * 2) + gridSpacing, alignment: .leading)
    }
}
