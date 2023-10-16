// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "red", type: .color, rightAnswer: true),
    ChoiceModel(item: "red", type: .color, rightAnswer: true),
    ChoiceModel(item: "yellow", type: .color),
]

private let choicesStep2 = [
    ChoiceModel(item: "blue", type: .color, rightAnswer: true),
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(item: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(item: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(item: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(item: "green", type: .color),
    ChoiceModel(item: "pink", type: .color, rightAnswer: true),
    ChoiceModel(item: "pink", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceModel(item: "red", type: .color, rightAnswer: true),
    ChoiceModel(item: "blue", type: .color),
    ChoiceModel(item: "red", type: .color, rightAnswer: true),
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
