import SwiftUI

struct CheckInQRCodeCard: View {
    let image: UIImage?

    var body: some View {
        ZStack {
            QrCornerBorder(
                cornerLength: 40,
                cornerRadius: 22
            )
            .stroke(
                BeastColors.primary,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .frame(
                width: 250,
                height: 250
            )

            ZStack {
                Color.white

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .padding(16)
                } else {
                    ProgressView()
                        .tint(BeastColors.primary)
                }
            }
            .frame(
                width: 210,
                height: 210
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
            .shadow(
                color: .black.opacity(0.12),
                radius: 10,
                x: 0,
                y: 5
            )
        }
        .frame(
            width: 250,
            height: 250
        )
    }
}
