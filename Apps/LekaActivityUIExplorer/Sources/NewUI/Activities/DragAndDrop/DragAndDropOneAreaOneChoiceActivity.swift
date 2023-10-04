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
    ContextViewModel(file: "basket", size: CGSize(width: 380, height: 280), hints: true)
]

private let context2 = [
    ContextViewModel(file: "kitchen_asset_1", size: CGSize(width: 380, height: 280), hints: false)
]

private let context3 = [
    ContextViewModel(file: "basket", size: CGSize(width: 380, height: 280), hints: true)
]

private let context4 = [
    ContextViewModel(file: "basket", size: CGSize(width: 380, height: 280), hints: true)
]

private let context5 = [
    ContextViewModel(file: "basket", size: CGSize(width: 380, height: 280), hints: true)
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
    @StateObject private var stepManager = StepManager(steps: steps)
    @State private var id = UUID()

    var body: some View {
        stepManager.interface.id(id)
    }
}

struct DDragAndDropOneAreaOneChoiceActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneAreaOneChoiceActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
