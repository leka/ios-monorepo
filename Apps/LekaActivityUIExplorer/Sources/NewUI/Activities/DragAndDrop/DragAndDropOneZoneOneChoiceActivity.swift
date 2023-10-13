// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let dropZonesStep1 = [
    DragAndDropZoneModel(
        value: "basket",
        choices: [
            choicesStep1[0]
        ])
]

private let choicesStep1 = [
    ChoiceModel(value: "watermelon", type: .image)
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(
        value: "basket",
        choices: [
            choicesStep2[0]
        ])
]

private let choicesStep2 = [
    ChoiceModel(value: "banana", type: .image)
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(
        value: "basket",
        choices: [
            choicesStep3[0]
        ])
]

private let choicesStep3 = [
    ChoiceModel(value: "kiwi", type: .image)
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(
        value: "basket",
        choices: [
            choicesStep4[0]
        ])
]

private let choicesStep4 = [
    ChoiceModel(value: "cherry", type: .image)
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(
        value: "basket",
        choices: [
            choicesStep5[0]
        ])
]

private let choicesStep5 = [
    ChoiceModel(value: "avocado", type: .image)
]

private var steps: [DragAndDropZoneStepModel] = [
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep1, choices: choicesStep1, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices(hints: true)),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep2, choices: choicesStep2, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices(hints: true)),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep3, choices: choicesStep3, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices(hints: true)),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep4, choices: choicesStep4, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices(hints: true)),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep5, choices: choicesStep5, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices(hints: true)),
]

struct DragAndDropOneZoneOneChoiceActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropOneZoneOneChoiceActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneZoneOneChoiceActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
