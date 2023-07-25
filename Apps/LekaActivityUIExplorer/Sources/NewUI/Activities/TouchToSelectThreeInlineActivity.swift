// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let step1 = [
    ChoiceViewModel(item: "red", type: .color),
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "yellow", type: .color),
]

private let step2 = [
    ChoiceViewModel(item: "purple", type: .color),
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "blue", type: .color, rightAnswer: true),
]

private let step3 = [
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "red", type: .color),
]

private let step4 = [
    ChoiceViewModel(item: "green", type: .color),
    ChoiceViewModel(item: "pink", type: .color),
    ChoiceViewModel(item: "yellow", type: .color, rightAnswer: true),
]

private let step5 = [
    ChoiceViewModel(item: "red", type: .color, rightAnswer: true),
    ChoiceViewModel(item: "blue", type: .color),
    ChoiceViewModel(item: "yellow", type: .color),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: step1, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step2, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step3, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step4, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step5, gameplay: .selectTheRightAnswer),
]

struct TouchToSelectThreeInlineActivity: View {
    @State var stepIndex = 0
    @State private var stepManager = StepManager(stepModel: steps[0])

    var body: some View {
        ThreeChoicesInlineView(gameplay: stepManager.gameplay)
            .onReceive(
                stepManager.state
            ) { state in
                if state == .finished {
                    Task {
                        await nextStep()
                    }
                }
            }
    }

    func nextStep() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            stepIndex += 1
            guard stepIndex < steps.count else { return }
            stepManager = StepManager(stepModel: steps[stepIndex])
        }
    }
}

struct TouchToSelectThreeInlineActivity_Previews: PreviewProvider {
    static var previews: some View {
        TouchToSelectThreeInlineActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
