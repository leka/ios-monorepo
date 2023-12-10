// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension DanceFreeze {
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
    DanceFreeze.FreezeView()
}
