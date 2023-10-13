// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let dropZonesStep1 = [
    DragAndDropZoneModel(value: "basket")
]

private let choicesStep1 = [
    DragAndDropChoiceModel(value: "kiwi", type: .image, dropZone: .first(dropZonesStep1)),
    DragAndDropChoiceModel(value: "watermelon", type: .image),
    DragAndDropChoiceModel(value: "cherry", type: .image),
    DragAndDropChoiceModel(value: "banana", type: .image),
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(value: "basket")
]

private let choicesStep2 = [
    DragAndDropChoiceModel(value: "watermelon", type: .image),
    DragAndDropChoiceModel(value: "cherry", type: .image, dropZone: .first),
    DragAndDropChoiceModel(value: "avocado", type: .image),
    DragAndDropChoiceModel(value: "banana", type: .image),
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(value: "basket")
]

private let choicesStep3 = [
    DragAndDropChoiceModel(value: "cherry", type: .image),
    DragAndDropChoiceModel(value: "avocado", type: .image),
    DragAndDropChoiceModel(value: "kiwi", type: .image, dropZone: .first),
    DragAndDropChoiceModel(value: "watermelon", type: .image),
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(value: "basket")
]

private let choicesStep4 = [
    DragAndDropChoiceModel(value: "banana", type: .image),
    DragAndDropChoiceModel(value: "cherry", type: .image),
    DragAndDropChoiceModel(value: "avocado", type: .image),
    DragAndDropChoiceModel(value: "kiwi", type: .image, dropZone: .first),
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(value: "basket")
]

private let choicesStep5 = [
    DragAndDropChoiceModel(value: "watermelon", type: .image, dropZone: .first),
    DragAndDropChoiceModel(value: "cherry", type: .image),
    DragAndDropChoiceModel(value: "avocado", type: .image),
    DragAndDropChoiceModel(value: "kiwi", type: .image),
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

struct DragAndDropOneZoneFourChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropOneZoneFourChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneZoneFourChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
