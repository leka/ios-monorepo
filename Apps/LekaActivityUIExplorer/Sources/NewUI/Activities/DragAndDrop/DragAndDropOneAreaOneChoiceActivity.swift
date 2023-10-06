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

private let dropArea1 = DropAreaModel(file: "basket", size: CGSize(width: 380, height: 280), hints: true)

private let dropArea2 = DropAreaModel(file: "kitchen_asset_1", size: CGSize(width: 380, height: 280), hints: false)

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
    StandardStepModel(
        choices: choicesStep2,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea2)),
    StandardStepModel(
        choices: choicesStep3,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
    StandardStepModel(
        choices: choicesStep4,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea2)),
    StandardStepModel(
        choices: choicesStep5,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneAreaOneOrMoreChoices(dropArea1)),
]

struct DragAndDropOneAreaOneChoiceActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropOneAreaOneChoiceActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneAreaOneChoiceActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
