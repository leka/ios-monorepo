// Leka - iOS Monorepo
// Copyright 2024 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

extension DanceFreezeView {
    struct DanceView: View {
        var body: some View {
            LottieView(
                name: "dance", speed: 0.5,
                loopMode: .loop
            )
        }
    }
}

#Preview {
    DanceFreezeView.DanceView()
}
