// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true)
]

private let choicesStep2 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true)
]

private let choicesStep3 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true)
]

private let choicesStep4 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true)
]

private let choicesStep5 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true)

]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .selectTheRightAnswer, interface: .oneChoice),
    StandardStepModel(choices: choicesStep2, gameplay: .selectTheRightAnswer, interface: .oneChoice),
    StandardStepModel(choices: choicesStep3, gameplay: .selectTheRightAnswer, interface: .oneChoice),
    StandardStepModel(choices: choicesStep4, gameplay: .selectTheRightAnswer, interface: .oneChoice),
    StandardStepModel(choices: choicesStep5, gameplay: .selectTheRightAnswer, interface: .oneChoice),
]

struct DragAndDropBasketOneChoiceActivity: View {
    @ObservedObject private var stepManager = StepManager(steps: steps)

    var body: some View {
        stepManager.interface
    }
}

struct DragAndDropBasketOneChoiceActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropBasketOneChoiceActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
