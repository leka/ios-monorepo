// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "cow", type: .text, rightAnswer: true),
    ChoiceModel(value: "sheep", type: .text),
    ChoiceModel(value: "cow", type: .text, rightAnswer: true),
    ChoiceModel(value: "horse", type: .text),
    ChoiceModel(value: "cow", type: .text, rightAnswer: true),
    ChoiceModel(value: "kangaroo", type: .text),
]

private let choicesStep2 = [
    ChoiceModel(value: "chinchilla", type: .text, rightAnswer: true),
    ChoiceModel(value: "frog", type: .text),
    ChoiceModel(value: "chinchilla", type: .text, rightAnswer: true),
    ChoiceModel(value: "cow", type: .text),
    ChoiceModel(value: "bird", type: .text),
    ChoiceModel(value: "horse", type: .text),
]

private let choicesStep3 = [
    ChoiceModel(value: "dog", type: .text, rightAnswer: true),
    ChoiceModel(value: "dog", type: .text, rightAnswer: true),
    ChoiceModel(value: "lama", type: .text),
    ChoiceModel(value: "dog", type: .text, rightAnswer: true),
    ChoiceModel(value: "cat", type: .text),
    ChoiceModel(value: "dog", type: .text, rightAnswer: true),
]

private let choicesStep4 = [
    ChoiceModel(value: "frog", type: .text),
    ChoiceModel(value: "panda", type: .text, rightAnswer: true),
    ChoiceModel(value: "bird", type: .text),
    ChoiceModel(value: "cow", type: .text),
    ChoiceModel(value: "sheep", type: .text),
    ChoiceModel(value: "horse", type: .text, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceModel(value: "sheep", type: .text, rightAnswer: true),
    ChoiceModel(value: "cat", type: .text),
    ChoiceModel(value: "horse", type: .text),
    ChoiceModel(value: "cow", type: .text),
    ChoiceModel(value: "sheep", type: .text, rightAnswer: true),
    ChoiceModel(value: "horse", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectSomeRightAnswers(2), interface: .sixChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .selectSomeRightAnswers(1), interface: .sixChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .selectSomeRightAnswers(3), interface: .sixChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .selectSomeRightAnswers(1), interface: .sixChoices),
    StandardStepModel(choices: choicesStep5, gameplay: .selectSomeRightAnswers(2), interface: .sixChoices),
]

struct SomeAnswersSixChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}
