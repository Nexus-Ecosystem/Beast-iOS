import SwiftUI
import PencilKit

struct SignaturePadView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var isSigning: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(isSigning: $isSigning)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(
            .pen,
            color: .black,
            width: 3
        )

        canvasView.backgroundColor = .white
        canvasView.isOpaque = true
        canvasView.isScrollEnabled = false
        canvasView.isUserInteractionEnabled = true
        canvasView.alwaysBounceVertical = false
        canvasView.alwaysBounceHorizontal = false

        return canvasView
    }

    func updateUIView(
        _ uiView: PKCanvasView,
        context: Context
    ) {
        uiView.drawingPolicy = .anyInput
        uiView.isUserInteractionEnabled = true
        uiView.isScrollEnabled = false
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding private var isSigning: Bool

        init(isSigning: Binding<Bool>) {
            _isSigning = isSigning
        }

        func canvasViewDrawingDidChange(
            _ canvasView: PKCanvasView
        ) {
            isSigning = !canvasView.drawing.strokes.isEmpty
        }
    }
}
