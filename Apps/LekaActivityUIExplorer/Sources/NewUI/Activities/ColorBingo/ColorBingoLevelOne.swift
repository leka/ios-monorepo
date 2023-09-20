// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true)
]

private let choicesStep2 = [
    ChoiceViewModel(item: "green", type: .color, rightAnswer: true)
]

private let choicesStep3 = [
    ChoiceViewModel(item: "pink", type: .color, rightAnswer: true)
]

private let choicesStep4 = [
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true)
]

private let choicesStep5 = [
    ChoiceViewModel(item: "red", type: .color, rightAnswer: true)

]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .colorBingo, interface: .oneChoice),
    StandardStepModel(choices: choicesStep2, gameplay: .colorBingo, interface: .oneChoice),
    StandardStepModel(choices: choicesStep3, gameplay: .colorBingo, interface: .oneChoice),
    StandardStepModel(choices: choicesStep4, gameplay: .colorBingo, interface: .oneChoice),
    StandardStepModel(choices: choicesStep5, gameplay: .colorBingo, interface: .oneChoice),
]

struct ColorBingoLevelOne: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct ColorBingoLevelOne_Previews: PreviewProvider {
    static var previews: some View {
        ColorBingoLevelOne()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
