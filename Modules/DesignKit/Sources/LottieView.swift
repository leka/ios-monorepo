// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

public extension LottieView {
    init(
        name: String,
        speed: CGFloat,
        loopMode: LottieLoopMode = .playOnce,
        _ completion: LottieCompletionBlock? = nil
    ) where Placeholder == EmptyView {
        let animation = LottieAnimation.named(name)!
        let view = LottieView(animation: animation)
            .configure {
                $0.loopMode = loopMode
                $0.animationSpeed = speed
                $0.play(completion: completion)
            }

        self = view
    }

    init(
        animation: LottieAnimation,
        speed: CGFloat,
        loopMode: LottieLoopMode = .playOnce,
        _ completion: LottieCompletionBlock? = nil
    ) where Placeholder == EmptyView {
        let view = Lottie.LottieView(animation: animation)
            .configure {
                $0.loopMode = loopMode
                $0.animationSpeed = speed
                $0.play(completion: completion)
            }

        self = view
    }
}
