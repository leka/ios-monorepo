// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choiceStep1 = [
    ChoiceModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(item: "xylophone", type: .text),
    ChoiceModel(item: "flute", type: .text),
    ChoiceModel(item: "saxophone", type: .text),
]

private let choiceStep2 = [
    ChoiceModel(item: "bass", type: .text),
    ChoiceModel(item: "harmonica", type: .text),
    ChoiceModel(item: "violin", type: .text),
    ChoiceModel(item: "guitar", type: .text, rightAnswer: true),
]

private let choiceStep3 = [
    ChoiceModel(item: "flute", type: .text),
    ChoiceModel(item: "piano", type: .text),
    ChoiceModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(item: "clarinet", type: .text),
]

private let choiceStep4 = [
    ChoiceModel(item: "violin", type: .text),
    ChoiceModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(item: "piano", type: .text),
    ChoiceModel(item: "harmonica", type: .text),
]

private let choiceStep5 = [
    ChoiceModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceModel(item: "trumpet", type: .text),
    ChoiceModel(item: "piano", type: .text),
    ChoiceModel(item: "battery", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choiceStep1, gameplay: .selectTheRightAnswer,
        interface: .listenFourChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep2, gameplay: .selectTheRightAnswer,
        interface: .listenFourChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep3, gameplay: .selectTheRightAnswer,
        interface: .listenFourChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep4, gameplay: .selectTheRightAnswer,
        interface: .listenFourChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep5, gameplay: .selectTheRightAnswer,
        interface: .listenFourChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
]

struct ListenThenTouchToSelectFourChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct ListenThenTouchToSelectFourChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        ListenThenTouchToSelectFourChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
