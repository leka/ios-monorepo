// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "red", type: .color),
    ChoiceModel(item: "green", type: .color, rightAnswer: true),
]

private let choicesStep2 = [
    ChoiceModel(item: "purple", type: .color),
    ChoiceModel(item: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(item: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(item: "pink", type: .color),
    ChoiceModel(item: "yellow", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceModel(item: "red", type: .color, rightAnswer: true),
    ChoiceModel(item: "green", type: .color),
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
