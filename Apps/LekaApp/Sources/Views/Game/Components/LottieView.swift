// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    // MARK: Lifecycle

    public init(
        name: String,
        speed: CGFloat = 1,
        reverse: Bool = false,
        action: @escaping () -> Void = { /* default empty closure */ },
        play: Binding<Bool> = .constant(true)
    ) {
        self.name = name
        self.speed = speed
        self.reverse = reverse
        self.action = action
        _play = play
    }

    // MARK: Internal

    typealias UIViewType = UIView

    class Coordinator: NSObject {
        // MARK: Lifecycle

        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }

        // MARK: Internal

        var parent: LottieView
    }

    var name: String!
    var speed: CGFloat
    var reverse: Bool
    var action: () -> Void
    @Binding var play: Bool

    var animationView = LottieAnimationView()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context _: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()

        self.animationView.animation = LottieAnimation.named(self.name)
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = self.speed
        self.animationView.loopMode = .playOnce
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.animationView)

        NSLayoutConstraint.activate([
            self.animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        return view
    }

    func updateUIView(_: UIView, context: UIViewRepresentableContext<LottieView>) {
        if self.play {
            if self.reverse {
                context.coordinator.parent.animationView.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .none) {
                    _ in
                    self.animationView.pause()
                }
            } else {
                context.coordinator.parent.animationView.play { finished in
                    if finished {
                        self.animationView.pause()
                        self.action()
                    }
                }
            }
        } else {
            if self.reverse {
                context.coordinator.parent.animationView.animationSpeed = self.speed * 1.5
                context.coordinator.parent.animationView.play(fromProgress: 1.0, toProgress: 0.0, loopMode: .none) {
                    _ in
                    context.coordinator.parent.animationView.stop()
                    context.coordinator.parent.animationView.animationSpeed = self.speed
                }
            } else {
                context.coordinator.parent.animationView.stop()
            }
        }
    }
}
