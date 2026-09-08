import SwiftUI
import PencilKit

struct SignaturePadView:
    UIViewRepresentable
{
    @Binding
    var canvasView: PKCanvasView

    @Binding
    var isSigning: Bool

    func makeCoordinator()
        -> Coordinator
    {
        Coordinator(
            isSigning:
                $isSigning
        )
    }

    func makeUIView(
        context: Context
    ) -> PKCanvasView {
        canvasView.backgroundColor =
            .white

        canvasView.isOpaque =
            true

        canvasView.drawingPolicy =
            .anyInput

        canvasView.tool =
            PKInkingTool(
                .pen,
                color: .black,
                width: 4
            )

        canvasView.isScrollEnabled =
            false

        canvasView.isUserInteractionEnabled =
            true

        canvasView.allowsFingerDrawing =
            true

        canvasView.delegate =
            context.coordinator

        let touchGesture =
            UILongPressGestureRecognizer(
                target:
                    context.coordinator,
                action:
                    #selector(
                        Coordinator.handleTouch(
                            _:
                        )
                    )
            )

        touchGesture.minimumPressDuration =
            0

        touchGesture.cancelsTouchesInView =
            false

        touchGesture.delegate =
            context.coordinator

        canvasView.addGestureRecognizer(
            touchGesture
        )

        return canvasView
    }

    func updateUIView(
        _ uiView: PKCanvasView,
        context: Context
    ) {
        uiView.tool =
            PKInkingTool(
                .pen,
                color: .black,
                width: 4
            )

        uiView.drawingPolicy =
            .anyInput

        uiView.isScrollEnabled =
            false

        uiView.isUserInteractionEnabled =
            true

        uiView.allowsFingerDrawing =
            true
    }

    final class Coordinator:
        NSObject,
        PKCanvasViewDelegate,
        UIGestureRecognizerDelegate
    {
        @Binding
        private var isSigning: Bool

        init(
            isSigning:
                Binding<Bool>
        ) {
            _isSigning =
                isSigning
        }

        @objc
        func handleTouch(
            _ gesture:
                UILongPressGestureRecognizer
        ) {
            switch gesture.state {
            case .began,
                 .changed:
                if !isSigning {
                    DispatchQueue.main.async {
                        self.isSigning =
                            true
                    }
                }

            case .ended,
                 .cancelled,
                 .failed:
                DispatchQueue.main.async {
                    self.isSigning =
                        false
                }

            default:
                break
            }
        }

        func gestureRecognizer(
            _ gestureRecognizer:
                UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith
            otherGestureRecognizer:
                UIGestureRecognizer
        ) -> Bool {
            true
        }

        func canvasViewDrawingDidChange(
            _ canvasView:
                PKCanvasView
        ) {}
    }
}
