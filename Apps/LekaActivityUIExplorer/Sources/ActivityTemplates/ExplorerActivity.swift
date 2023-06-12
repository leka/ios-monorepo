// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ExplorerActivity: ObservableObject {

    var withTemplate: Int
    var type: ActivityType

    init(withTemplate: Int, type: ActivityType) {
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
            randomAnswerPositions: true,
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
            Array(
                repeating: Step(
                    instruction: stepInstruction(), correctAnswer: setGoodAnswers()[0], allAnswers: setAnswersPerType(),
                    sound: nil), count: 5)
        ]
    }

    private func setAnswers() -> [String] {
        if withTemplate == 0 {
            return Array(stepAnswers.prefix(1))
        } else if withTemplate == 1 {
            return Array(stepAnswers.prefix(2))
        } else if 2...3 ~= withTemplate {
            return Array(stepAnswers.prefix(3))
        } else if 4...5 ~= withTemplate {
            return Array(stepAnswers.prefix(4))
        } else if withTemplate == 6 {
            return Array(stepAnswers.prefix(type == .touchToSelect ? 5 : 6))
        } else if withTemplate == 7 {
            return Array(stepAnswers.prefix(6))
        } else if withTemplate == 8 {
            return Array(stepAnswers.prefix(1))
        } else if withTemplate == 9 {
            return Array(stepAnswers.prefix(2))
        } else {
            return Array(stepAnswers.prefix(3))
        }
    }

    private func setDragAndDropAnswers() -> [String] {
        if withTemplate == 0 {
            return Array(dragAndDropAnswers.prefix(1))
        } else if withTemplate == 1 {
            return Array(dragAndDropAnswers.prefix(2))
        } else if withTemplate == 2 {
            return Array(dragAndDropAnswers.prefix(4))
        } else {
            return Array(dragAndDropAnswers.prefix(3))
        }
    }

    func setAnswersPerType() -> [String] {
        switch type {
            case .dragAndDrop:
                return setDragAndDropAnswers()
            default:
                return setAnswers()
        }
    }

    // ready to work with more than 1 good answers
    func setGoodAnswers() -> [String] {
        switch type {
            case .dragAndDrop:
                return ["watermelon"]
            default:
                return ["dummy_1"]
        }
    }

    var stepAnswers = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]
    var dragAndDropAnswers = ["watermelon", "banana", "kiwi", "avocado", "cherry", "strawberry"]

    func stepInstruction() -> LocalizedContent {
        return LocalizedContent(
            enUS: stepInstructions,
            frFR: stepInstructions)
    }

    var stepInstructions: String {
        switch type {
            case .touchToSelect:
                return "Touche le numéro 1"
            case .listenThenTouchToSelect:
                return "Touche le numéro 1"
            case .colorQuest:
                return "Touche la couleur verte"
            case .dragAndDrop:
                return "Fais glisser la pastèque dans le panier"
            case .xylophone:
                return "Joue du xylophone avec Leka"
            case .remote:
                return "Contrôle Leka avec la télécommande et fais le changer de couleur"
        }
    }

}
