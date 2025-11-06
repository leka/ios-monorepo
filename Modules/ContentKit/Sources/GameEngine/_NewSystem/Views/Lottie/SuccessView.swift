// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
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
            Text(l10n.SuccessFailureView.successCheeringLabel)
                .font(.largeTitle)
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
                CapsuleColoredButtonLabel(String(l10n.LottieAnimation.ActivityEnd.quitButtonLabel.characters), color: self.styleManager.accentColor!)
            }
        }
    }

    // MARK: Internal

    let percentage: Double

    // MARK: Private

    private let styleManager: StyleManager = .shared
}

#Preview {
    SuccessView(percentage: 65)
}
