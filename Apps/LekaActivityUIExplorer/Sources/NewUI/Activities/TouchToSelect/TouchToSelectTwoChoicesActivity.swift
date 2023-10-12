// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "red", type: .color),
    ChoiceModel(value: "green", type: .color, rightAnswer: true),
]

private let choicesStep2 = [
    ChoiceModel(value: "purple", type: .color),
    ChoiceModel(value: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(value: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(value: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(value: "pink", type: .color),
    ChoiceModel(value: "yellow", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceModel(value: "red", type: .color, rightAnswer: true),
    ChoiceModel(value: "green", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectTheRightAnswer, interface: .twoChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .selectTheRightAnswer, interface: .twoChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .selectTheRightAnswer, interface: .twoChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .selectTheRightAnswer, interface: .twoChoices),
    StandardStepModel(choices: choicesStep5, gameplay: .selectTheRightAnswer, interface: .twoChoices),
]

struct TouchToSelectTwoChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct TouchToSelectTwoChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        TouchToSelectTwoChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
