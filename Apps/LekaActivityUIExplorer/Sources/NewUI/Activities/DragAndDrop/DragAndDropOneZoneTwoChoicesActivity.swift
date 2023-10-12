// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

private let choicesStep1 = [
    ChoiceModel(value: "watermelon", type: .image),
    ChoiceModel(value: "banana", type: .image),
]

private let choicesStep2 = [
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "banana", type: .image),
]

private let choicesStep3 = [
    ChoiceModel(value: "kiwi", type: .image),
    ChoiceModel(value: "watermelon", type: .image),
]

private let choicesStep4 = [
    ChoiceModel(value: "cherry", type: .image),
    ChoiceModel(value: "avocado", type: .image),
]

private let choicesStep5 = [
    ChoiceModel(value: "avocado", type: .image),
    ChoiceModel(value: "kiwi", type: .image),
]

private let dropZonesStep1 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep1[1]
        ])
]

private let dropZonesStep2 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep2[0]
        ])
]

private let dropZonesStep3 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep3[0]
        ])
]

private let dropZonesStep4 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep4[1]
        ])
]

private let dropZonesStep5 = [
    DragAndDropZoneModel(
        value: "basket",
        size: CGSize(width: 380, height: 280),
        hints: false,
        choices: [
            choicesStep5[0]
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

struct DragAndDropOneZoneTwoChoicesActivity: View {
    private var stepManager = StepManager(steps: steps)

    var body: some View {
        StepView(stepManager: stepManager)
    }
}

struct DragAndDropOneAreaTwoChoicesActivity_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropOneZoneTwoChoicesActivity()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
