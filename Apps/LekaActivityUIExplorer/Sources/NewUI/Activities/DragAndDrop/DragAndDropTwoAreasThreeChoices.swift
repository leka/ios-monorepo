// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "banana", type: .image, rightAnswer: true),
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "watermelon", type: .image),
]

private let choicesStep2 = [
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "banana", type: .image, rightAnswer: true),
]

private let choicesStep3 = [
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "kiwi", type: .image, rightAnswer: true),
    ChoiceModel(value: "watermelon", type: .image),
]

private let choicesStep4 = [
    ChoiceModel(value: "banana", type: .image),
    ChoiceModel(value: "cherry", type: .image, rightAnswer: true),
    ChoiceModel(value: "avocado", type: .image),
]

private let choicesStep5 = [
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image, rightAnswer: true),
    ChoiceModel(value: "kiwi", type: .image),
]

private let dropZonesStep1 = [
    DragAndDropZoneModel(
        value: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep1[1],
            choicesStep1[0],
        ]),
    DragAndDropZoneModel(
        value: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep1[2]
        ]),
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(
        value: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep2[1]
        ]),
    DragAndDropZoneModel(
        value: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep2[2],
            choicesStep2[0],
        ]),
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(
        value: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep3[0]
        ]),
    DragAndDropZoneModel(
        value: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep3[2],
            choicesStep3[1],
        ]),
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(
        value: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep4[2],
            choicesStep4[0],
        ]),
    DragAndDropZoneModel(
        value: "bathroom_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep4[1]
        ]),
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(
        value: "kitchen_asset_1",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep5[0],
            choicesStep5[1],
        ]),
    DragAndDropZoneModel(
        value: "bathroom_asset_1",
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
