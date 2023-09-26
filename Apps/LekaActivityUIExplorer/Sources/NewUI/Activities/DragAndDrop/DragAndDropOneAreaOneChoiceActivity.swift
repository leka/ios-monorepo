// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "banana", type: .image, rightAnswer: true)
]

private let choicesStep2 = [
    ChoiceViewModel(item: "kiwi", type: .image, rightAnswer: true)
]

private let choicesStep3 = [
    ChoiceViewModel(item: "banana", type: .image, rightAnswer: true)
]

private let choicesStep4 = [
    ChoiceViewModel(item: "kiwi", type: .image, rightAnswer: true)
]

private let choicesStep5 = [
    ChoiceViewModel(item: "banana", type: .image, rightAnswer: true)
]

private let context = [
    ContextModel(
    name: "bathroom_asset_1",
    file: "bathroom_asset_1",
    size: CGSize(width: 385, height: 300),
    rightAnswers: ["banana"]),
]

private let context2 = [
    ContextModel(
    name: "bathroom_asset_1",
    file: "bathroom_asset_1",
    size: CGSize(width: 385, height: 300),
    rightAnswers: ["kiwi"]),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneChoiceOneArea(context)),
    StandardStepModel(
        choices: choicesStep2,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneChoiceOneArea(context2)),
    StandardStepModel(
        choices: choicesStep3,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneChoiceOneArea(context)),
    StandardStepModel(
        choices: choicesStep4,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneChoiceOneArea(context2)),
    StandardStepModel(
        choices: choicesStep5,
        gameplay: .selectTheRightAnswer,
        interface: .dragAndDropOneChoiceOneArea(context)),
]

struct DragAndDropOneAreaOneChoiceActivity: View {
    @ObservedObject private var stepManager = StepManager(steps: steps)

    var body: some View {
        stepManager.interface
    }
}

struct DragAndDropOneAreaOneChoiceActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneAreaOneChoiceActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
