// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Lottie
import SwiftUI

struct DanceLottieView: View {
    // MARK: Internal

    var body: some View {
        LottieView(
            animation: self.animation,
            speed: 0.5,
            loopMode: .loop
        )
    }

    // MARK: Private

    private let animation = LottieAnimation.named("dance_freeze_dance.animation.lottie", bundle: .module)!
}

#Preview {
    DanceLottieView()
}
