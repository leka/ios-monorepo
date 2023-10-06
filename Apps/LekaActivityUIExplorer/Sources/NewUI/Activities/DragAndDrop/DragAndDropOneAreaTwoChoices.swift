// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "banana", type: .image),
]

private let choicesStep2 = [
    ChoiceViewModel(item: "cherry", type: .image),
    ChoiceViewModel(item: "banana", type: .image, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceViewModel(item: "kiwi", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "watermelon", type: .image),
]

private let choicesStep4 = [
    ChoiceViewModel(item: "cherry", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "avocado", type: .image),
]

private let choicesStep5 = [
    ChoiceViewModel(item: "avocado", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "kiwi", type: .image),
]

private let dropArea1 = DropAreaModel(file: "basket", size: CGSize(width: 380, height: 280), hints: true)

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
    StandardStepModel(
        choices: choicesStep2,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
    StandardStepModel(
        choices: choicesStep3,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
    StandardStepModel(
        choices: choicesStep4,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
    StandardStepModel(
        choices: choicesStep5,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
]

struct DragAndDropOneAreaTwoChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropOneAreaTwoChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneAreaTwoChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
