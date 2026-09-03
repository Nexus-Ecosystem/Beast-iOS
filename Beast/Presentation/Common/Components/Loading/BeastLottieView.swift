import SwiftUI
import Lottie

struct BeastLottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode

    init(
        animationName: String,
        loopMode: LottieLoopMode = .loop
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .clear

        let animationView = LottieAnimationView(
            name: animationName
        )

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore

        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(
                equalTo: containerView.topAnchor
            ),
            animationView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor
            ),
            animationView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor
            ),
            animationView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor
            )
        ])

        animationView.play()

        return containerView
    }

    func updateUIView(
        _ uiView: UIView,
        context: Context
    ) {}

    static func dismantleUIView(
        _ uiView: UIView,
        coordinator: ()
    ) {
        uiView.subviews
            .compactMap { $0 as? LottieAnimationView }
            .forEach {
                $0.stop()
            }
    }
}
