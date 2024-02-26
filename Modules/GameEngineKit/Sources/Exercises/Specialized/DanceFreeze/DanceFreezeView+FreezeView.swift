// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

extension DanceFreezeView {
    struct FreezeView: View {
        var body: some View {
            LottieView(
                name: "freeze", speed: 0.5,
                loopMode: .loop
            )
        }
    }
}

#Preview {
    DanceFreezeView.FreezeView()
}
