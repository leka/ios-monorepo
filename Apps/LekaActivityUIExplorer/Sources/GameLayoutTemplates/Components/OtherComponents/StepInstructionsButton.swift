//
//  GLT_StepInstructionsButton.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

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
