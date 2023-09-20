// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "yellow", type: .color),
]

private let choicesStep2 = [
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let choicesStep4 = [
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
]

private let choicesStep5 = [
    ChoiceViewModel(item: "red", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: choicesStep1, gameplay: .colorQuest, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep2, gameplay: .colorQuest, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep3, gameplay: .colorQuest, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep4, gameplay: .colorQuest, interface: .threeChoicesInline),
    StandardStepModel(choices: choicesStep5, gameplay: .colorQuest, interface: .threeChoicesInline),
]

struct ColorQuest3: View {
    @ObservedObject private var stepManager = StepManager(steps: steps)

    var body: some View {
        stepManager.interface
    }
}

struct ColorQuest3_Previews: PreviewProvider {
    static var previews: some View {
        ColorQuest3()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
