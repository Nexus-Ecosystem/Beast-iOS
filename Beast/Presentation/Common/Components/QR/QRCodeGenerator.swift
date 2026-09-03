import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum QRCodeGenerator {
    private static let context = CIContext()
    private static let filter = CIFilter.qrCodeGenerator()

    static func generate(
        from value: String
    ) -> UIImage? {
        let data = Data(
            value.utf8
        )

        filter.message = data
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else {
            return nil
        }

        let transformedImage = outputImage.transformed(
            by: CGAffineTransform(
                scaleX: 12,
                y: 12
            )
        )

        guard let cgImage = context.createCGImage(
            transformedImage,
            from: transformedImage.extent
        ) else {
            return nil
        }

        return UIImage(
            cgImage: cgImage
        )
    }
}
