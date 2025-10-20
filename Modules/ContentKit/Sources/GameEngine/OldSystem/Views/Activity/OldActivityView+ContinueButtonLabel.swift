// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - OldActivityView.ContinueButtonLabel

extension OldActivityView {
    struct ContinueButtonLabel: View {
        var body: some View {
            Text(l10n.GameEngineKit.OldActivityView.continueButton)
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(width: 330, height: 80)
                .background(Capsule().fill(.green).shadow(radius: 1))
        }
    }
}

#Preview {
    OldActivityView.ContinueButtonLabel()
}
