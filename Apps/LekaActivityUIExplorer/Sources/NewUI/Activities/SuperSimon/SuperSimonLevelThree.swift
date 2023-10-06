// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep2 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep3 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep5 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep6 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "red", type: .color),
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
