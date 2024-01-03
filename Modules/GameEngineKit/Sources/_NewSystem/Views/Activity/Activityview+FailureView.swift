// Leka - iOS Monorepo
// Copyright 2024 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

extension ActivityView {
    struct FailureView: View {
        var body: some View {
            VStack(spacing: 40) {
                // TODO(@ladislas/@hugo): Use text variables to be localization friendly
                VStack {
                    Text("10% de réussite !")
                        .font(.largeTitle)
                        .foregroundStyle(.teal)
                        .padding(10)
                    Text("Essayez à nouveau !")
                        .font(.largeTitle)
                }

                LottieView(
                    animation: .tryAgain,
                    speed: 0.6
                )
                .frame(height: 500)
                .padding(-100)

                Button("Revenir au menu") {
                    UIApplication.shared.dismissAll(animated: true)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    ActivityView.FailureView()
}
