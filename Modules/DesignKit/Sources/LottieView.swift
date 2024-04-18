// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

public extension LottieView {
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
