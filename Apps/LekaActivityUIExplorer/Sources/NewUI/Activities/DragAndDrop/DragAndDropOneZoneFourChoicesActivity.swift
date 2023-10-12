// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "kiwi", type: .image),
    ChoiceModel(value: "watermelon", type: .image),
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "banana", type: .image),
]

private let choicesStep2 = [
    ChoiceModel(value: "watermelon", type: .image),
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "banana", type: .image),
]

private let choicesStep3 = [
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "kiwi", type: .image),
    ChoiceModel(value: "watermelon", type: .image),
]

private let choicesStep4 = [
    ChoiceModel(value: "banana", type: .image),
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "kiwi", type: .image),
]

private let choicesStep5 = [
    ChoiceModel(value: "watermelon", type: .image),
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "kiwi", type: .image),
]

private let dropZonesStep1 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep1[0]
        ])
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep2[3]
        ])
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep3[2]
        ])
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep4[1]
        ])
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep5[3]
        ])
]

private var steps: [DragAndDropZoneStepModel] = [
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep1, choices: choicesStep1, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep2, choices: choicesStep2, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep3, choices: choicesStep3, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep4, choices: choicesStep4, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep5, choices: choicesStep5, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneZoneOneOrMoreChoices),
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
