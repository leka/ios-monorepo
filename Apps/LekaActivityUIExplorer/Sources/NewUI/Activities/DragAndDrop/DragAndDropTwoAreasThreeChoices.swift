// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(item: "banana", type: .image, rightAnswer: true),
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "watermelon", type: .image),
]

private let choicesStep2 = [
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "avocado", type: .image),
    ChoiceModel(item: "banana", type: .image, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(item: "avocado", type: .image),
    ChoiceModel(item: "kiwi", type: .image, rightAnswer: true),
    ChoiceModel(item: "watermelon", type: .image),
]

private let choicesStep4 = [
    ChoiceModel(item: "banana", type: .image),
    ChoiceModel(item: "cherry", type: .image, rightAnswer: true),
    ChoiceModel(item: "avocado", type: .image),
]

private let choicesStep5 = [
    ChoiceModel(item: "cherry", type: .image),
    ChoiceModel(item: "avocado", type: .image, rightAnswer: true),
    ChoiceModel(item: "kiwi", type: .image),
]

private let dropZonesStep1 = [
    DragAndDropZoneModel(
        item: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep1[1],
            choicesStep1[0],
        ]),
    DragAndDropZoneModel(
        item: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep1[2]
        ]),
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(
        item: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep2[1]
        ]),
    DragAndDropZoneModel(
        item: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep2[2],
            choicesStep2[0],
        ]),
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(
        item: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep3[0]
        ]),
    DragAndDropZoneModel(
        item: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep3[2],
            choicesStep3[1],
        ]),
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(
        item: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep4[2],
            choicesStep4[0],
        ]),
    DragAndDropZoneModel(
        item: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep4[1]
        ]),
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(
        item: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep5[0],
            choicesStep5[1],
        ]),
    DragAndDropZoneModel(
        item: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep5[2]
        ]),
]

private var steps: [DragAndDropZoneStepModel] = [
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep1, choices: choicesStep1, gameplay: .dragAndDropAllAnswersOnTheRightZone,
        interface: .dragAndDropTwoAreasOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep2, choices: choicesStep2, gameplay: .dragAndDropAllAnswersOnTheRightZone,
        interface: .dragAndDropTwoAreasOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep3, choices: choicesStep3, gameplay: .dragAndDropAllAnswersOnTheRightZone,
        interface: .dragAndDropTwoAreasOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep4, choices: choicesStep4, gameplay: .dragAndDropAllAnswersOnTheRightZone,
        interface: .dragAndDropTwoAreasOneOrMoreChoices),
    DragAndDropZoneStepModel(
        dropZones: dropZonesStep5, choices: choicesStep5, gameplay: .dragAndDropAllAnswersOnTheRightZone,
        interface: .dragAndDropTwoAreasOneOrMoreChoices),
]

struct DragAndDropTwoAreasThreeChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropTwoAreasThreeChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropTwoAreasThreeChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
