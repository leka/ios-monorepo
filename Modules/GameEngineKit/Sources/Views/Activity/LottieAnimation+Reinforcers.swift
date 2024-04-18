// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie

extension LottieAnimation {
    static var reinforcer: LottieAnimation {
        LottieAnimation.named("reinforcer_spin_blink.animation.lottie", bundle: .module)!
    }

    static var bravo: LottieAnimation {
        LottieAnimation.named("activity_end_success.animation.lottie", bundle: .module)!
    }

    static var tryAgain: LottieAnimation {
        LottieAnimation.named("activity_end_try_again.animation.lottie", bundle: .module)!
    }
}
