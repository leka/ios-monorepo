// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let step1 = [
    ChoiceViewModel(item: "cow", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "dog", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "kangaroo", type: .text),
]

private let step2 = [
    ChoiceViewModel(item: "cat", type: .text),
    ChoiceViewModel(item: "frog", type: .text),
    ChoiceViewModel(item: "chinchilla", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "bird", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
]

private let step3 = [
    ChoiceViewModel(item: "dog", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "lama", type: .text),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "cat", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
]

private let step4 = [
    ChoiceViewModel(item: "frog", type: .text),
    ChoiceViewModel(item: "panda", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "bird", type: .text),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "sheep", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
]

private let step5 = [
    ChoiceViewModel(item: "lama", type: .text),
    ChoiceViewModel(item: "cat", type: .text),
    ChoiceViewModel(item: "horse", type: .text),
    ChoiceViewModel(item: "cow", type: .text),
    ChoiceViewModel(item: "sheep", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "horse", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(choices: step1, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step2, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step3, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step4, gameplay: .selectTheRightAnswer),
    StandardStepModel(choices: step5, gameplay: .selectTheRightAnswer),
]

public struct OneAnswerSixChoicesActivity: View {
    @State var stepIndex = 0
    @State private var stepManager = StepManager(stepModel: steps[0])

    public init() {
        // Nothing to do
    }

    public var body: some View {
        SixChoicesGridView(gameplay: stepManager.gameplay)
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
