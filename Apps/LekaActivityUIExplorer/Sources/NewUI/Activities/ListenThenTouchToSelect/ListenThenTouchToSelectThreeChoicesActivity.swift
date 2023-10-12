// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choiceStep1 = [
    ChoiceModel(value: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(value: "xylophone", type: .text),
    ChoiceModel(value: "flute", type: .text),
]

private let choiceStep2 = [
    ChoiceModel(value: "harmonica", type: .text),
    ChoiceModel(value: "violin", type: .text),
    ChoiceModel(value: "guitar", type: .text, rightAnswer: true),
]

private let choiceStep3 = [
    ChoiceModel(value: "flute", type: .text),
    ChoiceModel(value: "piano", type: .text),
    ChoiceModel(value: "guitar", type: .text, rightAnswer: true),
]

private let choiceStep4 = [
    ChoiceModel(value: "violin", type: .text),
    ChoiceModel(value: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(value: "piano", type: .text),
]

private let choiceStep5 = [
    ChoiceModel(value: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(value: "trumpet", type: .text),
    ChoiceModel(value: "harmonica", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choiceStep1, gameplay: .selectTheRightAnswer,
        interface: .listenThreeChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep2, gameplay: .selectTheRightAnswer,
        interface: .listenThreeChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep3, gameplay: .selectTheRightAnswer,
        interface: .listenThreeChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep4, gameplay: .selectTheRightAnswer,
        interface: .listenThreeChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep5, gameplay: .selectTheRightAnswer,
        interface: .listenThreeChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
]

struct ListenThenTouchToSelectThreeChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct ListenThenTouchToSelectThreeChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        ListenThenTouchToSelectThreeChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
