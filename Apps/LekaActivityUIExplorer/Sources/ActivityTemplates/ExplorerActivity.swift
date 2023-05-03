// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ExplorerActivity: ObservableObject {

    var withTemplate: Int
    var type: String

    init(withTemplate: Int, type: String) {
        self.withTemplate = withTemplate
        self.type = type
    }

    func makeActivity() -> Activity {
        return Activity(
            id: UUID(),
            title: emptyTitle,
            short: emptyShort,
            instructions: emptyInstructions(),
            activityType: type,
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
        } else if 4...5 ~= withTemplate {
            return stepAnswers4
        } else if withTemplate == 6 {
            return type == "touch_to_select" ? stepAnswers5 : stepAnswers6
        } else if withTemplate == 7 {
            return stepAnswers6
        } else if withTemplate == 8 {
            return stepAnswers1
        } else if withTemplate == 9 {
            return stepAnswers2
        } else {
            return stepAnswers3
        }
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

    var stepInstructionFR: String {
        guard type == "xylophone" else {
            return "Touche le numéro 1"
        }
        if type == "color_quest" {
            return "Touche la couleur verte"
        }
        return "Joue du xylophone avec Leka"
    }
    var stepInstructionEN: String {
        guard type == "xylophone" else {
            return "Touch the number 1"
        }
        guard withTemplate > 10 else {
            return "Touch the green color"
        }
        return "Play the xylophone with Leka"
    }

}
