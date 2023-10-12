// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "kiwi", type: .image),
    ChoiceModel(item: "watermelon", type: .image),
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "banana", type: .image),
]

private let choicesStep2 = [
    ChoiceModel(item: "watermelon", type: .image),
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "avocado", type: .image),
    ChoiceModel(item: "banana", type: .image),
]

private let choicesStep3 = [
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "avocado", type: .image),
    ChoiceModel(item: "kiwi", type: .image),
    ChoiceModel(item: "watermelon", type: .image),
]

private let choicesStep4 = [
    ChoiceModel(item: "banana", type: .image),
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "avocado", type: .image),
    ChoiceModel(item: "kiwi", type: .image),
]

private let choicesStep5 = [
    ChoiceModel(item: "watermelon", type: .image),
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "avocado", type: .image),
    ChoiceModel(item: "kiwi", type: .image),
]

private let dropZonesStep1 = [
    DragAndDropZoneModel(
        item: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep1[0]
        ])
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(
        item: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep2[3]
        ])
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(
        item: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep3[2]
        ])
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(
        item: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep4[1]
        ])
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(
        item: "basket",
        size: CGSize(width: 380, height: 280),
        hints: true,
        choices: [
            choicesStep5[3]
        ])
]

private var steps: [DragAndDropZoneStepModel] = [
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep1, choices: choicesStep1, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneAreaOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep2, choices: choicesStep2, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneAreaOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep3, choices: choicesStep3, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneAreaOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep4, choices: choicesStep4, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneAreaOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep5, choices: choicesStep5, gameplay: .dragAndDropOneAnswerOnTheRightZone,
        interface: .dragAndDropOneAreaOneOrMoreChoices),
]

struct DragAndDropOneAreaFourChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropOneAreaFourChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneAreaFourChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
