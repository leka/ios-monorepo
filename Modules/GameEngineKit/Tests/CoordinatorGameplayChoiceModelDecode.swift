// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit

import XCTest

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
              validate: true
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

        let exercise = NewExercise(yaml: kExercise)!

        let model = try JSONDecoder().decode(CoordinatorFindTheRightAnswersModel.self, from: exercise.payload!)

        XCTAssertEqual(model.choices.count, 6)
    }
}
