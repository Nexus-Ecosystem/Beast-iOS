import SwiftUI

struct ConfirmStudioDialog: View {
    let branch: BranchModel
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.72)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            VStack(spacing: 0) {
                imageHeader

                VStack(spacing: 18) {
                    studioInfoCard

                    Text(
                        "Puedes elegir más estudios después en tu perfil."
                    )
                    .font(
                        .system(
                            size: 10,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                    confirmButton
                    changeButton
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 18)
            }
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(
                    cornerRadius: 26,
                    style: .continuous
                )
                .fill(
                    BeastColors.surface
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 26,
                    style: .continuous
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: 26,
                    style: .continuous
                )
                .stroke(
                    BeastColors.border.opacity(0.7),
                    lineWidth: 1
                )
            )
            .shadow(
                color: .black.opacity(0.35),
                radius: 24,
                x: 0,
                y: 14
            )
            .padding(.horizontal, 28)
        }
    }

    private var imageHeader: some View {
        ZStack(alignment: .topTrailing) {
            branchImage

            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.18),
                    Color.black.opacity(0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Button {
                onCancel()
            } label: {
                Image(
                    systemName: "xmark"
                )
                .font(
                    .system(
                        size: 12,
                        weight: .black
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    width: 28,
                    height: 28
                )
                .background(
                    Circle()
                        .fill(
                            Color.black.opacity(0.65)
                        )
                )
            }
            .buttonStyle(.plain)
            .padding(12)

            VStack {
                Spacer()

                Text(
                    "¿CONFIRMAR ESTUDIO?"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .black
                    )
                )
                .italic()
                .foregroundStyle(.white)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 160)
    }

    @ViewBuilder
    private var branchImage: some View {
        if let first = branch.gallery.first,
           let url = URL(string: first) {
            AsyncImage(
                url: url
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    fallbackImage

                case .empty:
                    ZStack {
                        BeastColors.background
                        ProgressView()
                            .tint(BeastColors.primary)
                    }

                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        ZStack {
            BeastColors.background

            Image(
                systemName: "photo"
            )
            .font(
                .system(
                    size: 28,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
        }
    }

    private var studioInfoCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        BeastColors.background
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )

                Image(
                    systemName: "mappin.circle.fill"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    BeastColors.primary
                )
            }

            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                Text(
                    branch.name
                )
                .font(
                    .system(
                        size: 11,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    BeastColors.textSecondary
                )

                Text(
                    branch.phone
                )
                .font(
                    .system(
                        size: 14,
                        weight: .black
                    )
                )
                .foregroundStyle(
                    BeastColors.textPrimary
                )
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .frame(height: 64)
        .background(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .fill(
                BeastColors.background.opacity(0.75)
            )
        )
    }

    private var confirmButton: some View {
        Button {
            onConfirm()
        } label: {
            Text(
                "CONFIRMAR"
            )
            .font(
                .system(
                    size: 11,
                    weight: .black
                )
            )
            .tracking(0.8)
            .foregroundStyle(
                BeastColors.buttonText
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 48)
            .background(
                Capsule()
                    .fill(
                        BeastColors.primary
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var changeButton: some View {
        Button {
            onCancel()
        } label: {
            Text(
                "CAMBIAR"
            )
            .font(
                .system(
                    size: 11,
                    weight: .black
                )
            )
            .tracking(0.8)
            .foregroundStyle(
                BeastColors.textPrimary
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 44)
            .background(
                Capsule()
                    .fill(
                        BeastColors.background.opacity(0.8)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
