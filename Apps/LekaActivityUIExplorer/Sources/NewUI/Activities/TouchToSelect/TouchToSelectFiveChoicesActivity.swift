// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "cow", type: .text, rightAnswer: true),
    ChoiceModel(value: "sheep", type: .text),
    ChoiceModel(value: "horse", type: .text),
    ChoiceModel(value: "sheep", type: .text),
    ChoiceModel(value: "kangaroo", type: .text),
]

private let choicesStep2 = [
    ChoiceModel(value: "cat", type: .text),
    ChoiceModel(value: "frog", type: .text),
    ChoiceModel(value: "chinchilla", type: .text, rightAnswer: true),
    ChoiceModel(value: "bird", type: .text),
    ChoiceModel(value: "horse", type: .text),
]

private let choicesStep3 = [
    ChoiceModel(value: "dog", type: .text, rightAnswer: true),
    ChoiceModel(value: "sheep", type: .text),
    ChoiceModel(value: "lama", type: .text),
    ChoiceModel(value: "cow", type: .text),
    ChoiceModel(value: "horse", type: .text),
]

private let choicesStep4 = [
    ChoiceModel(value: "frog", type: .text),
    ChoiceModel(value: "panda", type: .text),
    ChoiceModel(value: "cow", type: .text),
    ChoiceModel(value: "sheep", type: .text, rightAnswer: true),
    ChoiceModel(value: "horse", type: .text),
]

private let choicesStep5 = [
    ChoiceModel(value: "lama", type: .text),
    ChoiceModel(value: "horse", type: .text),
    ChoiceModel(value: "cow", type: .text),
    ChoiceModel(value: "sheep", type: .text, rightAnswer: true),
    ChoiceModel(value: "horse", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectTheRightAnswer, interface: .fiveChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .selectTheRightAnswer, interface: .fiveChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .selectTheRightAnswer, interface: .fiveChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .selectTheRightAnswer, interface: .fiveChoices),
    StandardStepModel(choices: choicesStep5, gameplay: .selectTheRightAnswer, interface: .fiveChoices),
]

struct TouchToSelectFiveChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct TouchToSelectFiveChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        TouchToSelectFiveChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
