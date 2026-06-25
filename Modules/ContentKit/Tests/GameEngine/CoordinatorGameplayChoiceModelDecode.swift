// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import ContentKit

final class CoordinatorGameplayModelDecode: XCTestCase {
    func test_FindTheRightAnswer() throws {
        let kExercise =
            """
            instructions:
              - locale: fr_FR
                value: Touche les emojis qui sont identiques
              - locale: en_US
                value: Tap the emojis that are the same
            interface: touchToSelect
            gameplay: findTheRightAnswers
            action:
              type: ipad
              value:
                type: speech
                value:
                  - locale: fr_FR
                    utterance: "mets les bananes ensemble"
                  - locale: en_US
                    utterance: "put the bananas together"
            options:
              shuffle_choices: true
              validation:
                type: manual
            payload:
              choices:
                - value: 🍉
                  type: emoji
                  is_right_answer: true
                - value: 🍌
                  type: emoji
                - value: 🍒
                  type: emoji
                - value: 🍉
                  type: emoji
                  is_right_answer: true
                - value: 🥝
                  type: emoji
                - value: 🥥
                  type: emoji
            """

        let exercise = Exercise(yaml: kExercise)!

        let model = try JSONDecoder().decode(CoordinatorFindTheRightAnswersModel.self, from: exercise.payload!)

        XCTAssertEqual(model.choices.count, 6)
    }

    func test_FindTheRightNumber() throws {
        let kExercise =
            """
            instructions:
              - locale: fr_FR
                value: Touche le bon nombre d'emojis
              - locale: en_US
                value: Tap the right number of emojis
            interface: touchToSelect
            gameplay: findTheRightNumber
            action:
              type: robot
              value:
                type: image
                value: magicCardNumbers3Three
            options:
              shuffle_choices: true
              validation:
                type: manual
                minimumToSelect: 3
                maximumToSelect: 3
            payload:
              choices:
                - value: 🍉
                  type: emoji
                  is_right_answer: true
                - value: 🍉
                  type: emoji
                  is_right_answer: true
                - value: 🍉
                  type: emoji
                  is_right_answer: true
                - value: 🍉
                  type: emoji
                - value: 🐢
                  type: emoji
                - value: 🐢
                  type: emoji
            """

        let exercise = Exercise(yaml: kExercise)!

        XCTAssertEqual(exercise.gameplay, .findTheRightNumber)
        XCTAssertEqual(exercise.options?.validation, .manualWithSelectionLimit(minimumToSelect: 3, maximumToSelect: 3))

        let model = try JSONDecoder().decode(CoordinatorFindTheRightAnswersModel.self, from: exercise.payload!)

        XCTAssertEqual(model.choices.count, 6)
        XCTAssertEqual(model.choices.filter(\.isRightAnswer).count, 3)
    }

    func test_AssociateCategories() throws {
        let kExercise =
            """
            instructions:
              - locale: fr_FR
                value: Associe les emojis identiques
              - locale: en_US
                value: Associate the identical emojis
            interface: touchToSelect
            gameplay: associateCategories
            action:
              type: ipad
              value:
                type: speech
                value:
                  - locale: fr_FR
                    utterance: "mets les bananes ensemble"
                  - locale: en_US
                    utterance: "put the bananas together"
            options:
              shuffle_choices: true
              validation:
                type: manual
            payload:
              choices:
                - value: 🍉
                  type: emoji
                  category: catA
                - value: 🍌
                  type: emoji
                  category: catA
                - value: 🍒
                  type: emoji
                  category: catA
                - value: 🐶️
                  type: emoji
                  category: catB
                - value: 🐱
                  type: emoji
                  category: catA
                - value: 🐭
                  type: emoji
                  category: catB
            """

        let exercise = Exercise(yaml: kExercise)!

        let model = try JSONDecoder().decode(CoordinatorAssociateCategoriesModel.self, from: exercise.payload!)

        XCTAssertEqual(model.choices.count, 6)
    }

    func test_FindTheRightOrder() throws {
        let kExercise =
            """
            instructions:
              - locale: fr_FR
                value: Mets les emojis dans le bon ordre
              - locale: en_US
                value: Put the emojis in the right order
            interface: touchToSelect
            gameplay: findTheRightOrder
            action:
              type: ipad
              value:
                type: speech
                value:
                  - locale: fr_FR
                    utterance: "mets les bananes ensemble"
                  - locale: en_US
                    utterance: "put the bananas together"
            options:
              shuffle_choices: true
            payload:
              choices:
                - value: 1.circle
                  type: sfsymbol
                - value: 2.circle
                  type: sfsymbol
                - value: 3.circle
                  type: sfsymbol
                - value: 4.circle
                  type: sfsymbol
                - value: 5.circle
                  type: sfsymbol
                - value: 6.circle
                  type: sfsymbol
            """

        let exercise = Exercise(yaml: kExercise)!

        let model = try JSONDecoder().decode(CoordinatorFindTheRightOrderModel.self, from: exercise.payload!)

        XCTAssertEqual(model.choices.count, 6)
    }

    func test_OpenPlay() throws {
        let kExercise =
            """
            instructions:
              - locale: fr_FR
                value: Ouvre le jeu
              - locale: en_US
                value: Open the game
            interface: touchToSelect
            gameplay: openPlay
            action:
              type: ipad
              value:
                type: speech
                value:
                  - locale: fr_FR
                    utterance: "mets les bananes ensemble"
                  - locale: en_US
                    utterance: "put the bananas together"
            options:
              shuffle_choices: true
              validation:
                type: manual
                minimumToSelect: 2
                maximumToSelect: 3
            payload:
              choices:
                - value: 🍉
                  type: emoji
                - value: 🍌
                  type: emoji
                - value: 🍒
                  type: emoji
                - value: 🐶️
                  type: emoji
                - value: 🐱
                  type: emoji
                - value: 🐭
                  type: emoji
            """

        let exercise = Exercise(yaml: kExercise)!

        let model = try JSONDecoder().decode(CoordinatorOpenPlayModel.self, from: exercise.payload!)

        XCTAssertEqual(model.choices.count, 6)
    }
}
