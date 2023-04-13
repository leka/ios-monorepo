//
//  File.swift
//
//
//  Created by Mathieu Jeannot on 29/3/23.
//

import Foundation

// Use this activity for Quick Testing
// Create a baseActivity for the app when it launches (or when resetActivity())
class DemoActivity: ObservableObject {

    func makeBufferActivity() -> Activity {
        return Activity(
            id: UUID(),
            title: defaultTitle,
            short: defaultShort,
            instructions: defaultInstructions(),
            activityType: "touch_to_select",
            stepsAmount: 10,
            isRandom: true,
            numberOfImages: 1,
            randomAnswerPositions: true,
            stepSequence: makeDefaultSteps())
    }

    // MARK: - Default Values
    var defaultTitle = LocalizedContent(
        enUS: "Test Sample",
        frFR: "Échantillon de Test"
    )

    var defaultShort = LocalizedContent(
        enUS: "Test Sample - short",
        frFR: "Échantillon de Test - short"
    )

    func defaultInstructions() -> LocalizedContent {
        return LocalizedContent(
            enUS: String.markdownInstructionsEN,
            frFR: String.markdownInstructionsFR)
    }

    func makeDefaultSteps() -> [[Step]] {
        return [
            [
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers6, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers3, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
            ]
            //			[Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
            //			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
            //			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
            //			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil),
            //			 Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers1, sound: nil)
            //			]
        ]
    }

    var stepAnswers1 = ["dummy_1"]
    var stepAnswers2 = ["dummy_1", "dummy_2"]
    var stepAnswers3 = ["dummy_1", "dummy_2", "dummy_3"]
    var stepAnswers4 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4"]
    var stepAnswers5 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5"]
    var stepAnswers6 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]

    func stepInstruction() -> LocalizedContent {
        return LocalizedContent(
            enUS: stepInstructionEN,
            frFR: stepInstructionFR)
    }

    var stepInstructionFR: String = "Touche le numéro 1"
    var stepInstructionEN: String = "Touch the number 1"

}
