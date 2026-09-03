import SwiftUI

struct QrCheckInView: View {
    @StateObject private var viewModel = QrCheckInViewModel()

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Spacer()

                CheckInQRCodeCard(
                    image: viewModel.qrImage
                )

                Spacer()

                CheckInNipCard(
                    nip: viewModel.nip
                )

                Spacer()

                CheckInTimerView(
                    time: viewModel.formattedTime
                )

                Spacer()
                    .frame(height: 20)
            }
            .padding(
                .horizontal,
                24
            )

            if let error = viewModel.errorMessage {
                BeastAlertDialog(
                    style: .error,
                    message: error
                ) {
                    viewModel.resetError()
                }
                .zIndex(20)
            }
        }
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(
            .inline
        )
        .task {
            viewModel.load()
            await viewModel.startTimer()
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text(
                "LIST@ PARA LA ACCIÓN?"
            )
            .font(
                .system(
                    size: 12,
                    weight: .bold
                )
            )
            .tracking(2)
            .foregroundStyle(
                BeastColors.primary
            )

            Text(
                "TU CHECK-IN"
            )
            .font(
                .system(
                    size: 32,
                    weight: .black
                )
            )
            .italic()
            .foregroundStyle(
                BeastColors.textPrimary
            )

            Text(
                "Escanea este QR en la entrada de tu ESTUDIO o digita tu NIP de 4 dígitos."
            )
            .font(
                .system(
                    size: 14,
                    weight: .regular
                )
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )
            .multilineTextAlignment(
                .center
            )
            .lineSpacing(4)
            .padding(
                .horizontal,
                24
            )
            .padding(
                .top,
                8
            )
        }
        .padding(
            .top,
            8
        )
    }
}

#Preview {
    NavigationStack {
        QrCheckInView()
    }
}
