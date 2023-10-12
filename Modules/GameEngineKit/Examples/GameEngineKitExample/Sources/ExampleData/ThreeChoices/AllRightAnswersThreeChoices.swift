// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "red", type: .color, rightAnswer: true),
    ChoiceModel(value: "red", type: .color, rightAnswer: true),
    ChoiceModel(value: "yellow", type: .color),
]

private let choicesStep2 = [
    ChoiceModel(value: "blue", type: .color, rightAnswer: true),
    ChoiceModel(value: "green", type: .color),
    ChoiceModel(value: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(value: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(value: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(value: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(value: "green", type: .color),
    ChoiceModel(value: "pink", type: .color, rightAnswer: true),
    ChoiceModel(value: "pink", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceModel(value: "red", type: .color, rightAnswer: true),
    ChoiceModel(value: "blue", type: .color),
    ChoiceModel(value: "red", type: .color, rightAnswer: true),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectAllRightAnswers, interface: .threeChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .selectAllRightAnswers, interface: .threeChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .selectAllRightAnswers, interface: .threeChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .selectAllRightAnswers, interface: .threeChoices),
    StandardStepModel(choices: choicesStep5, gameplay: .selectAllRightAnswers, interface: .threeChoices),
]

struct AllAnswersThreeChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}
