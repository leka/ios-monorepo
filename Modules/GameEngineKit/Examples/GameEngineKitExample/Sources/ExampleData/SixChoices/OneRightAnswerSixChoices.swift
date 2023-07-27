// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "cow", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "dog", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "kangaroo", type: .text),
]

private let choicesStep2 = [
    ChoiceViewModel(item: "cat", type: .text),
    ChoiceViewModel(item: "frog", type: .text),
    ChoiceViewModel(item: "chinchilla", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "bird", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
]

private let choicesStep3 = [
    ChoiceViewModel(item: "dog", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "lama", type: .text),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "cat", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
]

private let choicesStep4 = [
    ChoiceViewModel(item: "frog", type: .text),
    ChoiceViewModel(item: "panda", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "bird", type: .text),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
]

private let choicesStep5 = [
    ChoiceViewModel(item: "lama", type: .text),
    ChoiceViewModel(item: "cat", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "sheep", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "horse", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectTheRightAnswer, interface: .sixChoices),
    StandardStepModel(choices: choicesStep2, gameplay: .selectTheRightAnswer, interface: .sixChoices),
    StandardStepModel(choices: choicesStep3, gameplay: .selectTheRightAnswer, interface: .sixChoices),
    StandardStepModel(choices: choicesStep4, gameplay: .selectTheRightAnswer, interface: .sixChoices),
    StandardStepModel(choices: choicesStep5, gameplay: .selectTheRightAnswer, interface: .sixChoices),
]

struct OneAnswerSixChoicesActivity: View {
    @ObservedObject private var stepManager = StepManager(steps: steps)

    var body: some View {
        stepManager.interface
    }
}
