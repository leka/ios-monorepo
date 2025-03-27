// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - DiscoverLekaView

public struct DiscoverLekaView: View {
    // MARK: Lifecycle

    public init(demoMode: Bool = false) {
        self.shared = ExerciseSharedData()
        self.robotManager = RobotManager(data: ExerciseSharedData(), demoMode: demoMode)
    }

    init(data: ExerciseSharedData? = nil, demoMode: Bool = false) {
        self.shared = data
        self.robotManager = RobotManager(data: data!, demoMode: demoMode)
    }

    // MARK: Public

    public var body: some View {
        VStack {
            Text(l10n.DiscoverLekaView.instructions)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Spacer()

            HStack(spacing: 180) {
                if self.isPlaying {
                    ActionButton(.pause, text: String(l10n.DiscoverLekaView.pauseButtonLabel.characters)) {
                        self.robotManager.pausePairing()
                        self.isPlaying = false
                    }
                } else {
                    ActionButton(.start, text: String(l10n.DiscoverLekaView.playButtonLabel.characters)) {
                        self.robotManager.startPairing()
                        self.isPlaying = true
                        self.hasStarted = true
                    }
                }

                ActionButton(.stop, text: String(l10n.DiscoverLekaView.stopButtonLabel.characters), hasStarted: self.hasStarted) {
                    self.robotManager.stopPairing()

                    self.isPlaying = false
                    self.hasStarted = false
                }
                .disabled(!self.hasStarted)
            }

            Spacer()
        }
        .onDisappear {
            self.shared?.state = .completed(level: .nonApplicable)
            self.robotManager.stopPairing()
            self.isPlaying = false
            self.hasStarted = false
        }
    }

    // MARK: Internal

    let robotManager: RobotManager
    let shared: ExerciseSharedData?

    // MARK: Private

    @State private var isPlaying: Bool = false
    @State private var hasStarted: Bool = false
}

#Preview {
    DiscoverLekaView()
}
