// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceViewModel(item: "watermelon", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "watermelon2", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "banana", type: .image, rightAnswer: true),
    ChoiceViewModel(item: "banana2", type: .image, rightAnswer: true),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectAllRightAnswers,
        interface: .dragAndDropAssociationFoutChoices),
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectAllRightAnswers,
        interface: .dragAndDropAssociationFoutChoices),
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectAllRightAnswers,
        interface: .dragAndDropAssociationFoutChoices),
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectAllRightAnswers,
        interface: .dragAndDropAssociationFoutChoices),
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .selectAllRightAnswers,
        interface: .dragAndDropAssociationFoutChoices),
]

struct DragAndDropAssociationFourChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropAssociationFourChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropAssociationFourChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
