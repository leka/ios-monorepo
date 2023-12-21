// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension ActivityView {
    struct SuccessView: View {
        var body: some View {
            ZStack {
                LottieView(
                    animation: .bravo, speed: 0.6
                )

                VStack {
                    // TODO(@ladislas/@hugo): Use text variables to be localization friendly
                    Text("90% de réussite !")
                        .font(.largeTitle)
                        .foregroundStyle(.teal)
                        .padding(10)
                    Text("Bravo, vous avez réussi cette activité !")
                        .font(.largeTitle)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ActivityView.SuccessView()
}
