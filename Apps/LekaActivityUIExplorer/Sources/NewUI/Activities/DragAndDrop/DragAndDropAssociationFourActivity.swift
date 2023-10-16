// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    AssociationChoiceModel(item: "watermelon", category: "watermelon", type: .image),
    AssociationChoiceModel(item: "watermelon2", category: "watermelon", type: .image),
    AssociationChoiceModel(item: "banana", category: "banana", type: .image),
    AssociationChoiceModel(item: "banana2", category: "banana", type: .image),
]

private let choicesStep2 = [
    AssociationChoiceModel(item: "watermelon3", category: "watermelon", type: .image),
    AssociationChoiceModel(item: "watermelon2", category: "watermelon", type: .image),
    AssociationChoiceModel(item: "banana3", category: "banana", type: .image),
    AssociationChoiceModel(item: "banana2", category: "banana", type: .image),
]

private var steps: [StandardStepModel] = [
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .association,
        interface: .dragAndDropAssociationFourChoices),
    StandardStepModel(
        choices: choicesStep2,
        gameplay: .association,
        interface: .dragAndDropAssociationFourChoices),
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .association,
        interface: .dragAndDropAssociationFourChoices),
    StandardStepModel(
        choices: choicesStep2,
        gameplay: .association,
        interface: .dragAndDropAssociationFourChoices),
    StandardStepModel(
        choices: choicesStep1,
        gameplay: .association,
        interface: .dragAndDropAssociationFourChoices),
]

struct DragAndDropAssociationFourActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropAssociationFourActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropAssociationFourActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
