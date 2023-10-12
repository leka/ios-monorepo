// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "red", type: .color),
    ChoiceModel(value: "blue", type: .color, rightAnswer: true),
    ChoiceModel(value: "yellow", type: .color),
]

private let choicesStep2 = [
    ChoiceModel(value: "purple", type: .color),
    ChoiceModel(value: "green", type: .color),
    ChoiceModel(value: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(value: "yellow", type: .color, rightAnswer: true),
    ChoiceModel(value: "blue", type: .color),
    ChoiceModel(value: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceModel(value: "green", type: .color),
    ChoiceModel(value: "pink", type: .color),
    ChoiceModel(value: "yellow", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceModel(value: "red", type: .color, rightAnswer: true),
    ChoiceModel(value: "blue", type: .color),
    ChoiceModel(value: "yellow", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .colorBingo, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep2, gameplay: .colorBingo, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep3, gameplay: .colorBingo, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep4, gameplay: .colorBingo, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep5, gameplay: .colorBingo, interface: .threeChoicesInline),
]

struct ColorBingoLevelThree: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct ColorBingoLevelThree_Previews: PreviewProvider {
    static var previews: some View {
        ColorBingoLevelThree()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
