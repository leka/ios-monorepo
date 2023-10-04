// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "green", type: .color, rightAnswer: true),
]

private let choicesStep2 = [
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceViewModel(item: "red", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "green", type: .color),
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
