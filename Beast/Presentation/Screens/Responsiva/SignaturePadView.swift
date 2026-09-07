import SwiftUI
import PencilKit

struct SignaturePadView:
    UIViewRepresentable
{
    @Binding
    var canvasView: PKCanvasView

    func makeUIView(
        context: Context
    ) -> PKCanvasView {
        canvasView.backgroundColor = .white

        canvasView.drawingPolicy =
            .anyInput

        canvasView.tool =
            PKInkingTool(
                .pen,
                color: .black,
                width: 4
            )

        canvasView.isScrollEnabled = false

        return canvasView
    }

    func updateUIView(
        _ uiView: PKCanvasView,
        context: Context
    ) {}
}
