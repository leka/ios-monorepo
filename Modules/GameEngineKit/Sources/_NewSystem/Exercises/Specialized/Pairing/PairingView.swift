// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - PairingView

struct PairingView: View {
    // MARK: Lifecycle

    init() {
        self.shared = ExerciseSharedData()
    }

    init(data: ExerciseSharedData? = nil) {
        self.shared = data
    }

    // MARK: Internal

    let robotManager = RobotManager()
    let shared: ExerciseSharedData?

    var body: some View {
        VStack {
            Text(l10n.PairingView.instructions)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Spacer()

            HStack(spacing: 180) {
                if self.isPlaying {
                    ActionButton(.pause, text: String(l10n.PairingView.pauseButtonLabel.characters)) {
                        self.robotManager.pausePairing()
                        self.isPlaying = false
                    }
                } else {
                    ActionButton(.start, text: String(l10n.PairingView.playButtonLabel.characters)) {
                        self.robotManager.startPairing()
                        self.isPlaying = true
                        self.hasStarted = true
                    }
                }

                ActionButton(.stop, text: String(l10n.PairingView.stopButtonLabel.characters), hasStarted: self.hasStarted) {
                    self.robotManager.stopPairing()

                    self.isPlaying = false
                    self.hasStarted = false
                }
                .disabled(!self.hasStarted)
            }

            Spacer()
        }
    }

    // MARK: Private

    @State private var isPlaying: Bool = false
    @State private var hasStarted: Bool = false
}

#Preview {
    PairingView()
}
