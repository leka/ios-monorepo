// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct NumberOfGroups: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var numberOfGroups: Float = 1

    var body: some View {
        Section {
            numberOfGroupsSlider
        } header: {
            Text("Nombre de groupes")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }

    private var numberOfGroupsSlider: some View {
        LabeledContent {
            Slider(
                value: $numberOfGroups,
                in: 1...5,
                step: 1,
                label: { /* no label */  },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(numberOfGroups))")
                },
                onEditingChanged: { _ in simulateGroups() }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
            .onAppear {
                numberOfGroups = Float(gameEngine.currentActivity.stepSequence.count)
            }
        } label: {
            Text("Groupes")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }

    private func simulateGroups() {
        gameEngine.bufferActivity.stepsAmount = 10
        gameEngine.bufferActivity.stepsAmount -=
            gameEngine.bufferActivity.stepsAmount % Int(numberOfGroups)
        let step = gameEngine.currentActivity.stepSequence[0][0]
        let group = Array(
            repeating: step,
            count: gameEngine.bufferActivity.stepsAmount / Int(numberOfGroups)
        )
        gameEngine.bufferActivity.stepSequence = Array(repeating: group, count: Int(numberOfGroups))
        for (index, group) in gameEngine.bufferActivity.stepSequence.enumerated() {
            for step in group.indices {
                gameEngine.bufferActivity.stepSequence[index][step].id = UUID()
            }
        }
        gameEngine.setupGame()
    }
}
