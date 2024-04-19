// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

extension ActivityView {
    struct SuccessView: View {
        let percentage: Int

        var body: some View {
            VStack(spacing: 40) {
                // TODO(@ladislas/@hugo): Use text variables to be localization friendly
                VStack {
                    Text("\(self.percentage)% de réussite !")
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.largeTitle)
                        .foregroundStyle(.teal)
                        .padding(10)
                    Text("Bravo, vous avez réussi cette activité !")
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.largeTitle)
                }

                LottieView(
                    animation: .bravo,
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
    ActivityView.SuccessView(percentage: 65)
}
