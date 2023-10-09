// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "yellow", type: .color),
]

private let choicesStep2 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "yellow", type: .color),
]

private let choicesStep3 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "yellow", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "yellow", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .superSimon([0]), interface: .fourChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .superSimon([0, 3]), interface: .fourChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .superSimon([0, 3, 1]), interface: .fourChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .superSimon([0, 3, 1, 2]), interface: .fourChoices),
]

struct SuperSimonLevelTwo: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct SuperSimonLevelTwo_Previews: PreviewProvider {
    static var previews: some View {
        SuperSimonLevelTwo()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
