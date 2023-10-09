// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "cow", type: .text, rightAnswer: true),
    ChoiceModel(item: "sheep", type: .text),
    ChoiceModel(item: "cow", type: .text, rightAnswer: true),
    ChoiceModel(item: "horse", type: .text),
    ChoiceModel(item: "cow", type: .text, rightAnswer: true),
    ChoiceModel(item: "kangaroo", type: .text),
]

private let choicesStep2 = [
    ChoiceModel(item: "chinchilla", type: .text, rightAnswer: true),
    ChoiceModel(item: "frog", type: .text),
    ChoiceModel(item: "chinchilla", type: .text, rightAnswer: true),
    ChoiceModel(item: "cow", type: .text),
    ChoiceModel(item: "bird", type: .text),
    ChoiceModel(item: "horse", type: .text),
]

private let choicesStep3 = [
    ChoiceModel(item: "dog", type: .text, rightAnswer: true),
    ChoiceModel(item: "dog", type: .text, rightAnswer: true),
    ChoiceModel(item: "lama", type: .text),
    ChoiceModel(item: "dog", type: .text, rightAnswer: true),
    ChoiceModel(item: "cat", type: .text),
    ChoiceModel(item: "dog", type: .text, rightAnswer: true),
]

private let choicesStep4 = [
    ChoiceModel(item: "frog", type: .text),
    ChoiceModel(item: "panda", type: .text, rightAnswer: true),
    ChoiceModel(item: "bird", type: .text),
    ChoiceModel(item: "cow", type: .text),
    ChoiceModel(item: "sheep", type: .text),
    ChoiceModel(item: "horse", type: .text),
]

private let choicesStep5 = [
    ChoiceModel(item: "sheep", type: .text, rightAnswer: true),
    ChoiceModel(item: "cat", type: .text),
    ChoiceModel(item: "horse", type: .text),
    ChoiceModel(item: "cow", type: .text),
    ChoiceModel(item: "sheep", type: .text, rightAnswer: true),
    ChoiceModel(item: "horse", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectAllRightAnswers, interface: .sixChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .selectAllRightAnswers, interface: .sixChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .selectAllRightAnswers, interface: .sixChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .selectAllRightAnswers, interface: .sixChoices),
    StandardStepModel(choices: choicesStep5, gameplay: .selectAllRightAnswers, interface: .sixChoices),
]

struct AllAnswersSixChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}
