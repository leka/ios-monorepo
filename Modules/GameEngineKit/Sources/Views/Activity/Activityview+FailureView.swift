// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import Lottie
import SwiftUI

// MARK: - ActivityView.FailureView

extension ActivityView {
    struct FailureView: View {
        let percentage: Double

        var body: some View {
            VStack(spacing: 40) {
                VStack {
                    Text(l10n.SuccessFailureView.successPercentageLabel(self.percentage))
                        .font(.largeTitle)
                        .foregroundStyle(.teal)
                        .padding(10)
                    Text(l10n.SuccessFailureView.failureCheeringLabel)
                        .font(.largeTitle)
                }

                LottieView(
                    animation: .tryAgain,
                    speed: 0.6
                )
                .frame(height: 500)
                .padding(-100)

                Button(String(l10n.SuccessFailureView.quitButtonLabel.characters)) {
                    // TODO: (@mathieu) - Save displayable data in session
                    UIApplication.shared.dismissAll(animated: true)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ActivityView.FailureView(percentage: 6)
}
