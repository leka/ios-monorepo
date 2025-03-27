// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - ActivityView.ContinueButtonLabel

extension ActivityView {
    struct ContinueButtonLabel: View {
        var body: some View {
            Text(l10n.GameEngineKit.ActivityView.continueButton)
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(width: 330, height: 80)
                .background(Capsule().fill(.green).shadow(radius: 1))
        }
    }
}

#Preview {
    ActivityView.ContinueButtonLabel()
}
