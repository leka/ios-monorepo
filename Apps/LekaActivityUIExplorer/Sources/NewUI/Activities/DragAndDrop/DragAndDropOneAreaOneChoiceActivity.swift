// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true)
]

private let choicesStep2 = [
    ChoiceViewModel(item: "banana", type: .image, rightAnswer: true)
]

private let choicesStep3 = [
    ChoiceViewModel(item: "kiwi", type: .image, rightAnswer: true)
]

private let choicesStep4 = [
    ChoiceViewModel(item: "cherry", type: .image, rightAnswer: true)
]

private let choicesStep5 = [
    ChoiceViewModel(item: "avocado", type: .image, rightAnswer: true)
]

private let context1 = [
    ContextViewModel(
        name: "basket",
        file: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        rightAnswers: ["watermelon"])
]

private let context2 = [
    ContextViewModel(
        name: "basket",
        file: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        rightAnswers: ["banana"])
]

private let context3 = [
    ContextViewModel(
        name: "basket",
        file: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        rightAnswers: ["kiwi"])
]

private let context4 = [
    ContextViewModel(
        name: "basket",
        file: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        rightAnswers: ["cherry"])
]

private let context5 = [
    ContextViewModel(
        name: "basket",
        file: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        rightAnswers: ["avocado"])
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneChoice(context1)),
    StandardStepModel(
        choices: choicesStep2,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneChoice(context2)),
    StandardStepModel(
        choices: choicesStep3,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneChoice(context3)),
    StandardStepModel(
        choices: choicesStep4,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneChoice(context4)),
    StandardStepModel(
        choices: choicesStep5,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneChoice(context5)),
]

struct DragAndDropOneAreaOneChoiceActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DDragAndDropOneAreaOneChoiceActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneAreaOneChoiceActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
