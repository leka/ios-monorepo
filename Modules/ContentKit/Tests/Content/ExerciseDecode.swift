// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
import Yams

@testable import ContentKit

let kTestExerciseMock =
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

// MARK: - ExerciseDecode

final class ExerciseDecode: XCTestCase {
    func test_decodeWithYamlDecoder() throws {
        let exercise = try YAMLDecoder().decode(NewExercise.self, from: kTestExerciseMock)

        XCTAssertEqual(exercise.interface, .general(.touchToSelect))
        XCTAssertEqual(exercise.gameplay, .findTheRightAnswers)

        XCTAssertEqual(exercise.options.shuffleChoices, true)
        XCTAssertEqual(exercise.options.validate, true)

        if case .some(.ipad) = exercise.action {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .ipad(type: .speech(_)) but got \(String(describing: exercise.action))")
        }
    }

    func test_decodeFromYamlString() throws {
        let exercise = NewExercise(yaml: kTestExerciseMock)

        XCTAssertNotNil(exercise)

        if let exercise {
            XCTAssertEqual(exercise.interface, .general(.touchToSelect))
            XCTAssertEqual(exercise.gameplay, .findTheRightAnswers)

            XCTAssertEqual(exercise.options.shuffleChoices, true)
            XCTAssertEqual(exercise.options.validate, true)

            if case .some(.ipad) = exercise.action {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected .ipad(type: .speech(_)) but got \(String(describing: exercise.action))")
            }
        }
    }
}
