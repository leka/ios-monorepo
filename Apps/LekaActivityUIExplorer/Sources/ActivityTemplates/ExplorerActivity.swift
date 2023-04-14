// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ExplorerActivity: ObservableObject {

    var withTemplate: Int

    init(withTemplate: Int) {
        self.withTemplate = withTemplate
    }

    func makeActivity() -> Activity {
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
        enUS: "Templates testing in english",
        frFR: "Test des templates en français"
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

    func makeEmptyStepArray() -> [[Step]] {
        return [
            [
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: setAnswers(), sound: nil),
            ]
        ]
    }

    private func setAnswers() -> [String] {
        if withTemplate == 0 {
            return stepAnswers1
        } else if withTemplate == 1 {
            return stepAnswers2
        } else if 2...3 ~= withTemplate {
            return stepAnswers3
        } else if 4...6 ~= withTemplate {
            return stepAnswers4
        } else {
            return stepAnswers6
        }
    }

    var stepAnswers1 = ["dummy_1"]
    var stepAnswers2 = ["dummy_1", "dummy_2"]
    var stepAnswers3 = ["dummy_1", "dummy_2", "dummy_3"]
    var stepAnswers4 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4"]
    var stepAnswers6 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]

    func stepInstruction() -> LocalizedContent {
        return LocalizedContent(
            enUS: stepInstructionEN,
            frFR: stepInstructionFR)
    }

    var stepInstructionFR: String = "Touche le numéro 1"
    var stepInstructionEN: String = "Touch the number 1"
}
