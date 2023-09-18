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
        Activity(
            id: UUID(),
            title: emptyTitle,
            short: emptyShort,
            instructions: emptyInstructions(),
            activityType: type,
            stepsAmount: 5,
            isRandom: true,
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
        LocalizedContent(
            enUS: String.markdownInstructionsEN,
            frFR: String.markdownInstructionsFR)
    }

    // swiftlint:disable trailing_comma
    func makeEmptyStepArray() -> [[Step]] {
        [
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
                return stepAnswers
            case .basket1, .dropArea1, .dropArea2Asset1:
                return Array(dragAndDropAnswers.prefix(1))
            case .basket2, .dropArea2Assets2:
                return Array(dragAndDropAnswers.prefix(2))
            case .basket4:
                return Array(dragAndDropAnswers.prefix(4))
            case .basketEmpty, .dropArea3:
                return Array(dragAndDropAnswers.prefix(3))
            case .dropArea2Assets6:
                return dragAndDropAnswers
            case .association4:
                return association4Answers
            case .association6:
                return association6Answers
            case .colorQuest1:
                return Array(colorAnswers.prefix(1))
            case .colorQuest2:
                return Array(colorAnswers.prefix(2))
            case .colorQuest3:
                return Array(colorAnswers.prefix(3))
            case .melody1:
                return melodyAnswers
            case .remoteStandard, .remoteArrow, .xylophone, .danceFreeze, .hideAndSeek:
                return [""]
        }
    }

    private func setGoodAnswers() -> [CorrectAnswers] {
        switch interface {
            case .basket1, .basket2, .basket4:
                return [CorrectAnswers(context: "basket", answers: ["watermelon"])]
            case .dropArea1, .dropArea3:
                return [CorrectAnswers(context: "kitchen_asset_1", answers: ["watermelon"])]
            case .dropArea2Asset1:
                return [
                    CorrectAnswers(context: "kitchen_asset_1", answers: ["watermelon"]),
                    CorrectAnswers(context: "bathroom_asset_1", answers: []),
                ]
            case .basketEmpty:
                return [CorrectAnswers(context: "basket", answers: ["watermelon", "banana"])]
            case .dropArea2Assets2:
                return [
                    CorrectAnswers(context: "kitchen_asset_1", answers: ["watermelon"]),
                    CorrectAnswers(context: "bathroom_asset_1", answers: ["banana"]),
                ]
            case .dropArea2Assets6:
                return [
                    CorrectAnswers(context: "kitchen_assets_3", answers: ["watermelon", "banana", "kiwi"]),
                    CorrectAnswers(context: "bathroom_assets_3", answers: ["avocado", "cherry", "strawberry"]),
                ]
            case .association4:
                return [
                    CorrectAnswers(context: "watermelon", answers: ["watermelon", "watermelon2"]),
                    CorrectAnswers(context: "banana", answers: ["banana", "banana2"]),
                ]
            case .association6:
                return [
                    CorrectAnswers(context: "watermelon", answers: ["watermelon", "watermelon2", "watermelon3"]),
                    CorrectAnswers(context: "banana", answers: ["banana", "banana2", "banana3"]),
                ]
            case .colorQuest1, .colorQuest2, .colorQuest3:
                return [CorrectAnswers(context: "context", answers: ["green"])]
            case .melody1:
                return [CorrectAnswers(context: "context", answers: ["green"])]
            case .remoteStandard, .remoteArrow, .xylophone, .danceFreeze:
                return [CorrectAnswers(context: "context", answers: [])]
            default:
                return [CorrectAnswers(context: "context", answers: ["dummy_1"])]
        }
    }
    // swiftlint:enable cyclomatic_complexity

    private func setSound() -> [String]? {
        switch type {
            case .listenThenTouchToSelect:
                return ["guitar"]
            case .danceFreeze:
                return ["guitar"]
            default:
                return nil
        }
    }

    var stepAnswers = ["dummy_1", "dummy_2", "dummy_3", "dummy_4", "dummy_5", "dummy_6"]
    var colorAnswers = ["green", "purple", "red", "yellow", "blue"]
    var dragAndDropAnswers = ["watermelon", "banana", "kiwi", "avocado", "cherry", "strawberry"]
    var association4Answers = ["watermelon", "watermelon2", "banana", "banana2"]
    var association6Answers = ["watermelon", "watermelon2", "watermelon3", "banana", "banana2", "banana3"]
    var melodyAnswers = ["pink", "red", "orange", "yellow", "green", "blue", "purple"]

    func stepInstruction() -> LocalizedContent {
        LocalizedContent(
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
                    case .dropArea1, .dropArea3, .dropArea2Asset1:
                        return "Fais glisser la pastèque dans la cuisine"
                    case .dropArea2Assets2, .dropArea2Assets6:
                        return "Fais glisser chaque objet sur l'image qui convient"
                    case .association4:
                        return "Fais le tri en catégories de 2 images"
                    case .association6:
                        return "Fais le tri en catégories de 3 images"
                    default:
                        return "Fais glisser la pastèque dans le panier"
                }
            case .xylophone:
                return "Joue du xylophone avec Leka"
            case .remote:
                return "Contrôle Leka avec la télécommande et fais le changer de couleur"
            case .danceFreeze:
                return "Danse avec Leka au rythme de la musique et faits la statue lorsqu’il s’arrête"
            case .melody:
                return "Touche la même couleur que celle de Leka"
            case .hideAndSeek:
                return "Cache le robot quelque part dans la pièce. Suis ensuite les instructions. "
        }
    }

}
