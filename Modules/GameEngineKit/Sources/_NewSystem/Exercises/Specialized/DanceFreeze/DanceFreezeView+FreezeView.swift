// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
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
