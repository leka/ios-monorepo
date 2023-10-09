// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "yellow", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep2 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "yellow", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep3 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "yellow", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "yellow", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep5 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "yellow", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep6 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "yellow", type: .color),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "red", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .superSimon([5]), interface: .sixChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .superSimon([5, 2]), interface: .sixChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .superSimon([5, 2, 4]), interface: .sixChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .superSimon([5, 2, 4, 1]), interface: .sixChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .superSimon([5, 2, 4, 1, 3]), interface: .sixChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .superSimon([5, 2, 4, 1, 3, 0]), interface: .sixChoices),
]

struct SuperSimonLevelThree: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct SuperSimonLevelThree_Previews: PreviewProvider {
    static var previews: some View {
        SuperSimonLevelThree()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
