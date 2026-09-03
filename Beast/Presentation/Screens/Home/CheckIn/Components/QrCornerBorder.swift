import SwiftUI

struct QrCornerBorder: Shape {
    var cornerLength: CGFloat = 34
    var cornerRadius: CGFloat = 22

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        // TOP LEFT
        path.move(
            to: CGPoint(
                x: minX,
                y: minY + cornerLength
            )
        )

        path.addLine(
            to: CGPoint(
                x: minX,
                y: minY + cornerRadius
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: minX + cornerRadius,
                y: minY
            ),
            control: CGPoint(
                x: minX,
                y: minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: minX + cornerLength,
                y: minY
            )
        )

        // TOP RIGHT
        path.move(
            to: CGPoint(
                x: maxX - cornerLength,
                y: minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: maxX - cornerRadius,
                y: minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: maxX,
                y: minY + cornerRadius
            ),
            control: CGPoint(
                x: maxX,
                y: minY
            )
        )

        path.addLine(
            to: CGPoint(
                x: maxX,
                y: minY + cornerLength
            )
        )

        // BOTTOM RIGHT
        path.move(
            to: CGPoint(
                x: maxX,
                y: maxY - cornerLength
            )
        )

        path.addLine(
            to: CGPoint(
                x: maxX,
                y: maxY - cornerRadius
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: maxX - cornerRadius,
                y: maxY
            ),
            control: CGPoint(
                x: maxX,
                y: maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: maxX - cornerLength,
                y: maxY
            )
        )

        // BOTTOM LEFT
        path.move(
            to: CGPoint(
                x: minX + cornerLength,
                y: maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: minX + cornerRadius,
                y: maxY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: minX,
                y: maxY - cornerRadius
            ),
            control: CGPoint(
                x: minX,
                y: maxY
            )
        )

        path.addLine(
            to: CGPoint(
                x: minX,
                y: maxY - cornerLength
            )
        )

        return path
    }
}
