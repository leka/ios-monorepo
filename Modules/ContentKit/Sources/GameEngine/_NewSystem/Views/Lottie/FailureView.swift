// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import Lottie
import SwiftUI

// MARK: - FailureView

public struct FailureView: View {
    // MARK: Lifecycle

    public init(percentage: Double) {
        self.percentage = percentage
    }

    // MARK: Public

    public var body: some View {
        VStack(spacing: 40) {
            Text(l10n.LottieAnimation.ActivityEnd.failureCheeringLabel)
                .font(.largeTitle)
                .padding(.top, 50)

            LottieView(
                animation: .tryAgain,
                speed: 0.6
            )
            .frame(height: 500)
            .offset(y: -100)

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
    FailureView(percentage: 6)
}
