// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct StepInstructionsButton: View {

    @EnvironmentObject var gameEngine: GameEngine

    var body: some View {
        Button(gameEngine.stepInstruction) {
            gameEngine.speak(sentence: gameEngine.stepInstruction)
        }
        .buttonStyle(StepInstructions_ButtonStyle())
    }
}
