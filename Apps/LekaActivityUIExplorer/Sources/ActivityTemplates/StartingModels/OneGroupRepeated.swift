//
//  OneGroupRepeated.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import Foundation

class OneGroupRepeated: ObservableObject {

    func makeEmptyActivity() -> Activity {
        return Activity(
            id: UUID(),
            title: emptyTitle,
            short: emptyShort,
            instructions: emptyInstructions(),
            activityType: "touch_to_select",
            stepsAmount: 10,
            isRandom: false,
            numberOfImages: 1,
            randomAnswerPositions: false,
            stepSequence: makeEmptyStepArray())
    }

    // MARK: - Empty Activity Values
    var emptyTitle = LocalizedContent(
        enUS: "One group Sequence, repeated once",
        frFR: "Séquence d'un seul groupe, répété une fois"
    )

    var emptyShort = LocalizedContent(
        enUS: "Subject - 1",
        frFR: "Sujet - 1"
    )

    func emptyInstructions() -> LocalizedContent {
        return LocalizedContent(
            enUS: String.markdownInstructionsEN,
            frFR: String.markdownInstructionsFR)
    }

    func emptyStep() -> Step {
        return Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil)
    }

    func makeEmptyStepArray() -> [[Step]] {
        return [
            [
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers3, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
            ]
        ]
    }

    var stepAnswers1 = ["dummy_1"]
    var stepAnswers2 = ["dummy_1", "dummy_2"]
    var stepAnswers3 = ["dummy_1", "dummy_2", "dummy_3"]
    var stepAnswers4 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4"]

    func stepInstruction() -> LocalizedContent {
        return LocalizedContent(
            enUS: stepInstructionEN,
            frFR: stepInstructionFR)
    }

    var stepInstructionFR: String = "Touche le numéro 1"
    var stepInstructionEN: String = "Touch the number 1"
}
