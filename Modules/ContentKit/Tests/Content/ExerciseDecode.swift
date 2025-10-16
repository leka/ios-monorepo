// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import ContentKit

let kTestExerciseMockOne =
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
        type: automatic
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

let kTestExerciseMockTwo =
    """
    instructions:
      - locale: fr_FR
        value: "T'aimes / T'aime pas"
      - locale: en_US
        value: "Like it or not "
    interface: dragAndDropGridWithZones
    gameplay: openPlay
    options:
      shuffle_choices: false
      validation:
        type: manual
        minimumToSelect: 2
    payload:
      choices:
        - value: 😍
          type: emoji
          is_dropzone: true
        - value: ☹️
          type: emoji
          is_dropzone: true
        - value: 🍏
          type: emoji
        - value: 🌮
          type: emoji
        - value: 🍓
          type: emoji
        - value: 🍩
          type: emoji
        - value: 🍊
          type: emoji
        - value: 💩
          type: emoji
    """

// MARK: - ExerciseDecode

final class ExerciseDecode: XCTestCase {
    func test_decodeAutomaticListenSpeechThenTTSShuffledFromYamlString() throws {
        let exercise = Exercise(yaml: kTestExerciseMockOne)

        XCTAssertNotNil(exercise)

        if let exercise {
            XCTAssertEqual(exercise.interface, .general(.touchToSelect))
            XCTAssertEqual(exercise.gameplay, .findTheRightAnswers)

            XCTAssertEqual(exercise.options?.shuffleChoices, true)
            XCTAssertEqual(exercise.options?.validation, .automatic)

            if case .some(.ipad) = exercise.action {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected .ipad(type: .speech(_)) but got \(String(describing: exercise.action))")
            }
        }
    }

    func test_decodeDnDWithZonesOpenPlayFromYamlString() throws {
        let exercise = Exercise(yaml: kTestExerciseMockTwo)
        var minimumToSelect: Int?
        var maximumToSelect: Int?

        XCTAssertNotNil(exercise)

        if let exercise {
            XCTAssertEqual(exercise.interface, .general(.dragAndDropGridWithZones))
            XCTAssertEqual(exercise.gameplay, .openPlay)

            XCTAssertEqual(exercise.options?.shuffleChoices, false)
            XCTAssertEqual(exercise.options?.validation, .manualWithSelectionLimit(minimumToSelect: minimumToSelect, maximumToSelect: maximumToSelect))
            XCTAssertEqual(minimumToSelect, 2)
            XCTAssertEqual(maximumToSelect, nil)
        }
    }
}
