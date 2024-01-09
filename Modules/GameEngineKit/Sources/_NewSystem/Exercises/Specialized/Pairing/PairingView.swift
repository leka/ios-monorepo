// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - PairingView

struct PairingView: View {
    // MARK: Lifecycle

    init(instructions: Pairing.Payload.Instructions) {
        self.instructions = instructions
        self.shared = ExerciseSharedData()
    }

    init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? Pairing.Payload else {
            fatalError("Exercise payload is not .selection")
        }

        self.instructions = payload.instructions
        self.shared = data
    }

    // MARK: Internal

    let instructions: Pairing.Payload.Instructions
    let robotManager = RobotManager()
    let shared: ExerciseSharedData?

    var body: some View {
        VStack {
            Text(self.instructions.textMainInstructions)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Spacer()

            HStack(spacing: 180) {
                if self.isPlaying {
                    ActionButton(.pause, text: self.instructions.textButtonPause) {
                        print("Pairing behavior is pausing")
                        self.robotManager.pausePairing()
                        self.isPlaying = false
                    }
                } else {
                    ActionButton(.start, text: self.instructions.textButtonPlay) {
                        print("Pairing behavior is running")
                        self.robotManager.startPairing()
                        self.isPlaying = true
                        self.hasStarted = true
                    }
                }

                ActionButton(.stop, text: self.instructions.textButtonStop, hasStarted: self.hasStarted) {
                    print("Pairing behavior stopped")
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
    let instructions = Pairing.Payload.Instructions(
        textMainInstructions: "Instructions principales",
        textButtonPlay: "Jouer",
        textButtonPause: "Pause",
        textButtonStop: "Stop"
    )

    return PairingView(instructions: instructions)
}
