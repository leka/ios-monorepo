// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension ActivityView {
    struct FailureView: View {
        var body: some View {
            ZStack {
                LottieView(
                    animation: .tryAgain, speed: 0.6
                )

                VStack {
                    // TODO(@ladislas/@hugo): Use text variables to be localization friendly
                    Text("10% de réussite !")
                        .font(.largeTitle)
                        .foregroundStyle(.teal)
                        .padding(10)
                    Text("Essayez à nouveau !")
                        .font(.largeTitle)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ActivityView.FailureView()
}
