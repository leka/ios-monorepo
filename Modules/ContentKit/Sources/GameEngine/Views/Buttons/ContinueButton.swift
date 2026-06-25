// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - ContinueButton

public struct ContinueButton: View {
    // MARK: Lifecycle

    init(_ onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }

    // MARK: Public

    public var body: some View {
        Button {
            self.onContinue()
        } label: {
            Text(l10n.ContinueButton.buttonLabel)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .padding()
    }

    // MARK: Internal

    let onContinue: () -> Void
}

// MARK: - l10n.ContinueButton

extension l10n {
    enum ContinueButton {
        static let buttonLabel = LocalizedString(
            "game_engine_kit.continue_button.button_label",
            bundle: ContentKitResources.bundle,
            value: "Continue",
            comment: "The label of the continue button"
        )
    }
}

#Preview {
    ContinueButton {
        print("Let's continue")
    }
}
