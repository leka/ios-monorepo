// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest
import Yams

@testable import GameEngineKit

let kActivityYaml = """
      options:
        shuffle_exercises: false
        shuffle_groups: false

      exercise_groups:
        - group:
            - instructions:
                - locale: fr_FR
                  value: Touche les emojis qui sont identiques
                - locale: en_US
                  value: Tap the emojis that are the same
              interface: touchToSelect
              gameplay: associateCategories
              payload:
                shuffle_choices: true
                choices:
                  - value: 🐶
                    type: emoji
                    category: catA
                  - value: 🐶
                    type: emoji
                    category: catA
                  - value: 🐱
                    type: emoji
                    category: catB
                  - value: 🐱
                    type: emoji
                    category: catB
                  - value: 🐷
                    type: emoji
                    category: catC
                  - value: 🐷
                    type: emoji
                    category: catC
    """

// MARK: - ActivityPayloadDecode

final class ActivityPayloadDecode: XCTestCase {
    func testExample() throws {
        let payload = try YAMLDecoder().decode(ActivityPayload.self, from: kActivityYaml)

        XCTAssertEqual(payload.exerciseGroups.count, 1)
        XCTAssertEqual(payload.exerciseGroups[0].group.count, 1)
        XCTAssertEqual(payload.options.shuffleExercises, false)
    }
}
