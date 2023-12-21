// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

public struct LottieView: UIViewRepresentable {
    // MARK: Lifecycle

    public init(
        name: String,
        speed: CGFloat = 1,
        reverse: Bool = false,
        loopMode: LottieLoopMode = .playOnce,
        action: @escaping () -> Void = {
            // empty default implementation
        },
        play _: Binding<Bool> = .constant(true)
    ) {
        let animation = LottieAnimation.named(name)!
        self.init(animation: animation, speed: speed, reverse: reverse, loopMode: loopMode, action: action)
    }

    public init(
        animation: LottieAnimation,
        speed: CGFloat = 1,
        reverse: Bool = false,
        loopMode: LottieLoopMode = .playOnce,
        action: @escaping () -> Void = {
            // empty default implementation
        },
        play: Binding<Bool> = .constant(true)
    ) {
        self.animation = animation
        self.speed = speed
        self.reverse = reverse
        self.loopMode = loopMode
        self.action = action
        _play = play
    }

    // MARK: Public

    public typealias UIViewType = UIView

    public class Coordinator: NSObject {
        // MARK: Lifecycle

        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }

        // MARK: Internal

        var parent: LottieView
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context _: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()

        self.animationView.animation = self.animation
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = self.speed
        self.animationView.loopMode = self.loopMode
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.animationView)

        NSLayoutConstraint.activate([
            self.animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        return view
    }

    public func updateUIView(_: UIView, context: UIViewRepresentableContext<LottieView>) {
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

    // MARK: Internal

    var animation: LottieAnimation
    var speed: CGFloat
    var reverse: Bool
    var loopMode: LottieLoopMode
    var action: () -> Void
    @Binding var play: Bool

    var animationView = LottieAnimationView()
}
