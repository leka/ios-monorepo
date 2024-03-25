// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

extension DanceFreezeView {
    struct FreezeView: View {
        // MARK: Internal

        var body: some View {
            LottieView(
                animation: self.animation,
                speed: 0.5,
                loopMode: .loop
            )
        }

        // MARK: Private

        private let animation = LottieAnimation.named("dance_freeze_freeze.animation.lottie", bundle: .module)!
    }
}

#Preview {
    DanceFreezeView.FreezeView()
}
