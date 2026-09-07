import SwiftUI

struct BranchCardView:
    View
{
    let branch:
        BranchModel

    let onSubscribe:
        () -> Void

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            HStack(
                alignment: .top
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(
                        branch.name
                    )
                    .font(
                        .system(
                            size: 20,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(
                        BeastColors.textPrimary
                    )

                    Text(
                        "PREMIUM STUDIO"
                    )
                    .font(
                        .system(
                            size: 9,
                            weight: .black
                        )
                    )
                    .tracking(1)
                    .foregroundStyle(
                        BeastColors.primary
                    )
                }

                Spacer()

                HStack(
                    spacing: 4
                ) {
                    Image(
                        systemName:
                            "star.fill"
                    )

                    Text(
                        String(
                            format:
                                "%.1f",
                            branch.rating
                        )
                    )
                }
                .font(
                    .system(
                        size: 11,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
                .padding(
                    .horizontal,
                    10
                )
                .padding(
                    .vertical,
                    7
                )
                .background(
                    Capsule()
                        .fill(
                            BeastColors.background
                        )
                )
            }

            image

            HStack(
                spacing: 12
            ) {
                Image(
                    systemName:
                        "mappin.circle.fill"
                )
                .foregroundStyle(
                    BeastColors.primary
                )

                Text(
                    branch.address
                )
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
            }

            HStack(
                spacing: 10
            ) {
                contact(
                    icon: "phone.fill",
                    value: branch.phone
                )

                contact(
                    icon:
                        "envelope.fill",
                    value: branch.email
                )
            }

            Button {
                onSubscribe()
            } label: {
                Text(
                    "SUSCRIBIRSE"
                )
                .font(
                    .system(
                        size: 11,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    BeastColors.buttonText
                )
                .frame(
                    maxWidth:
                        .infinity
                )
                .frame(
                    height: 48
                )
                .background(
                    Capsule()
                        .fill(
                            BeastColors.primary
                        )
                )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(
                cornerRadius: 26,
                style:
                    .continuous
            )
            .fill(
                BeastColors.surface
            )
        )
    }

    @ViewBuilder
    private var image:
        some View
    {
        if let first =
            branch.gallery.first,
           let url =
            URL(
                string: first
            )
        {
            AsyncImage(
                url: url
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                BeastColors.background
            }
            .frame(height: 160)
            .frame(
                maxWidth:
                    .infinity
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18,
                    style:
                        .continuous
                )
            )
        } else {
            ZStack {
                BeastColors.background

                Image(
                    systemName:
                        "photo"
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )
            }
            .frame(height: 160)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18,
                    style:
                        .continuous
                )
            )
        }
    }

    private func contact(
        icon: String,
        value: String
    ) -> some View {
        HStack(
            spacing: 7
        ) {
            Image(
                systemName:
                    icon
            )
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                value
            )
            .lineLimit(1)
            .foregroundStyle(
                BeastColors.textSecondary
            )
        }
        .font(
            .system(
                size: 9,
                weight: .medium
            )
        )
        .frame(
            maxWidth:
                .infinity
        )
        .padding(
            .vertical,
            10
        )
        .background(
            RoundedRectangle(
                cornerRadius: 12
            )
            .fill(
                BeastColors.background
            )
        )
    }
}
