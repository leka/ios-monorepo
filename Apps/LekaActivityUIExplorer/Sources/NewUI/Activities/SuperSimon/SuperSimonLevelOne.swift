// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color),
]

private let choicesStep2 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .superSimon([1]), interface: .twoChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .superSimon([1, 0]), interface: .twoChoices),
]

struct SuperSimonLevelOne: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct SuperSimonLevelOne_Previews: PreviewProvider {
    static var previews: some View {
        SuperSimonLevelOne()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
