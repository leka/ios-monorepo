// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choiceStep1 = [
    ChoiceViewModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "xylophone", type: .text),
]

private let choiceStep2 = [
    ChoiceViewModel(item: "violin", type: .text),
    ChoiceViewModel(item: "guitar", type: .text, rightAnswer: true),
]

private let choiceStep3 = [
    ChoiceViewModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "clarinet", type: .text),
]

private let choiceStep4 = [
    ChoiceViewModel(item: "violin", type: .text),
    ChoiceViewModel(item: "guitar", type: .text, rightAnswer: true),
]

private let choiceStep5 = [
    ChoiceViewModel(item: "guitar", type: .text, rightAnswer: true),
    ChoiceViewModel(item: "trumpet", type: .text),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choiceStep1, gameplay: .selectTheRightAnswer,
        interface: .listenTwoChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep2, gameplay: .selectTheRightAnswer,
        interface: .listenTwoChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep3, gameplay: .selectTheRightAnswer,
        interface: .listenTwoChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep4, gameplay: .selectTheRightAnswer,
        interface: .listenTwoChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
    StandardStepModel(
        choices: choiceStep5, gameplay: .selectTheRightAnswer,
        interface: .listenTwoChoices(AudioRecordingModel(name: "guitar", file: "guitar"))),
]

struct ListenThenTouchToSelectTwoChoicesActivity: View {
    @StateObject private var stepManager = StepManager(steps: steps)

    var body: some View {
        stepManager.interface
    }
}

struct ListenThenTouchToSelectTwoChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        ListenThenTouchToSelectTwoChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
