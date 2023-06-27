// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ExplorerActivity: ObservableObject {

    var type: ActivityType
    var interface: GameLayout

    init(type: ActivityType, interface: GameLayout) {
        self.type = type
        self.interface = interface
    }

    func makeActivity() -> Activity {
        return Activity(
            id: UUID(),
            title: emptyTitle,
            short: emptyShort,
            instructions: emptyInstructions(),
            activityType: type,
            stepsAmount: 5,
            isRandom: false,
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

    // swiftlint:disable trailing_comma
    func makeEmptyStepArray() -> [[Step]] {
        return [
            Array(
                repeating: Step(
                    interface: interface,
                    instruction: stepInstruction(),
                    correctAnswers: setGoodAnswers(),
                    allAnswers: setAnswers(),
                    sound: setSound()),
                count: 5)
        ]
    }
    // swiftlint:enable trailing_comma

    // swiftlint:disable cyclomatic_complexity
    private func setAnswers() -> [String] {
        switch interface {
            case .touch1, .soundTouch1:
                return Array(stepAnswers.prefix(1))
            case .touch2, .soundTouch2:
                return Array(stepAnswers.prefix(2))
            case .touch3, .soundTouch3, .touch3Inline, .soundTouch3Inline:
                return Array(stepAnswers.prefix(3))
            case .touch4, .soundTouch4, .touch4Inline, .soundTouch4Inline:
                return Array(stepAnswers.prefix(4))
            case .touch5:
                return Array(stepAnswers.prefix(5))
            case .touch6, .soundTouch6:
                return Array(stepAnswers.prefix(6))
            case .basket1, .dropArea1, .dropArea2Asset1:
                return Array(dragAndDropAnswers.prefix(1))
            case .basket2:
                return Array(dragAndDropAnswers.prefix(2))
            case .basket4:
                return Array(dragAndDropAnswers.prefix(4))
            case .basketEmpty, .dropArea3:
                return Array(dragAndDropAnswers.prefix(3))
            case .colorQuest1:
                return Array(colorAnswers.prefix(1))
            case .colorQuest2:
                return Array(colorAnswers.prefix(2))
            case .colorQuest3:
                return Array(colorAnswers.prefix(3))
            case .remoteStandard, .remoteArrow, .xylophone, .danceFreeze, .hideAndSeek:
                return [""]
        }
    }
    // swiftlint:enable cyclomatic_complexity

    // ready to work with more than 1 good answers
    private func setGoodAnswers() -> [[String]] {
        switch interface {
            case .basket1, .basket2, .basket4, .dropArea1, .dropArea3, .dropArea2Asset1:
                return [["watermelon"]]
            case .basketEmpty:
                return [["watermelon", "banana"]]
            case .colorQuest1, .colorQuest2, .colorQuest3:
                return [["green"]]
            case .remoteStandard, .remoteArrow, .xylophone, .danceFreeze:
                return [[""]]
            default:
                return [["dummy_1"]]
        }
    }

    private func setSound() -> [String]? {
        switch type {
            case .listenThenTouchToSelect:
                return ["guitar"]
            case .danceFreeze:
                return ["nyan"]
            default:
                return nil
        }
    }

    var stepAnswers = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]
    var colorAnswers = ["green", "purple", "red", "yellow", "blue"]
    var dragAndDropAnswers = ["watermelon", "banana", "kiwi", "avocado", "cherry", "strawberry"]

    func stepInstruction() -> LocalizedContent {
        return LocalizedContent(
            enUS: stepInstructions,
            frFR: stepInstructions)
    }

    var stepInstructions: String {
        switch type {
            case .touchToSelect, .listenThenTouchToSelect:
                return "Touche le numéro 1"
            case .colorQuest:
                return "Touche la couleur verte"
            case .dragAndDrop:
                switch interface {
                    case .basketEmpty:
                        return "Fais glisser la pastèque et la banane dans le panier"
                    case .dropArea1, .dropArea3:
                        return "Fais glisser la pastèque dans la cuisine"
                    case .dropArea2Asset1:
                        return "Fais glisser chaque objet sur l'image correspodante"
                    default:
                        return "Fais glisser la pastèque dans le panier"
                }
            case .xylophone:
                return "Joue du xylophone avec Leka"
            case .remote:
                return "Contrôle Leka avec la télécommande et fais le changer de couleur"
            case .danceFreeze:
                return "Danse avec Leka au rythme de la musique et faits la statue lorsqu’il s’arrête"
            case .hideAndSeek:
                return "Cache le robot quelque part dans la pièce. Suis ensuite les instructions. "
        }
    }

}
