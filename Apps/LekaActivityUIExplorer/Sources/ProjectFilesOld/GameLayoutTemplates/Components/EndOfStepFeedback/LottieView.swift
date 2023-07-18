// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    var name: String!
    var speed: CGFloat
    var reverse: Bool
    var loopMode: LottieLoopMode
    var action: () -> Void
    @Binding var play: Bool

    public init(
        name: String,
        speed: CGFloat = 1,
        reverse: Bool = false,
        loopMode: LottieLoopMode = .playOnce,
        action: @escaping () -> Void = {
            // empty default implementation
        },
        play: Binding<Bool> = .constant(true)
    ) {
        self.name = name
        self.speed = speed
        self.reverse = reverse
        self.loopMode = loopMode
        self.action = action
        self._play = play
    }

    var animationView = LottieAnimationView()

    class Coordinator: NSObject {
        var parent: LottieView

        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()

        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = speed
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if play {
            if reverse {
                context.coordinator.parent.animationView.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .none) {
                    _ in
                    animationView.pause()
                }
            } else {
                context.coordinator.parent.animationView.play { finished in
                    if finished {
                        animationView.pause()
                        action()
                    }
                }
            }
        } else {
            if reverse {
                context.coordinator.parent.animationView.animationSpeed = speed * 1.5
                context.coordinator.parent.animationView.play(fromProgress: 1.0, toProgress: 0.0, loopMode: .none) {
                    _ in
                    context.coordinator.parent.animationView.stop()
                    context.coordinator.parent.animationView.animationSpeed = speed
                }
            } else {
                context.coordinator.parent.animationView.stop()
            }
        }
    }
}
