// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import Lottie
import SwiftUI

// MARK: - SuccessView

public struct SuccessView: View {
    // MARK: Lifecycle

    public init(percentage: Double) {
        self.percentage = percentage
    }

    // MARK: Public

    public var body: some View {
        VStack {
            VStack {
                Text(l10n.LottieAnimation.ActivityEnd.successPercentageLabel(self.percentage))
                    .font(.largeTitle)
                    .foregroundStyle(.teal)
                    .padding(10)
                Text(l10n.SuccessFailureView.successCheeringLabel)
                    .font(.largeTitle)
            }
            .padding(.top, 50)

            LottieView(
                animation: .bravo,
                speed: 0.6
            )
            .frame(height: 500)
            .offset(y: -50)

            Button {
                // TODO: (@mathieu) - Save displayable data in session
                UIApplication.shared.dismissAll(animated: true)
            } label: {
                Text(l10n.LottieAnimation.ActivityEnd.quitButtonLabel)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: Internal

    let percentage: Double
}

#Preview {
    SuccessView(percentage: 65)
}
