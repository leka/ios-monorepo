// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import ContentKit

let kTestActivityMock: String =
    """
    version: 1.0.0

    uuid: F8C90919AF204155A170D3957BABE7D6
    name: TestActivityMock

    created_at: "2024-06-17T17:38:12.804177"
    last_edited_at: "2024-09-10T23:15:58.558407"

    status: template
    launch_requirements:
      robot:
        minimum_firmware: "1.2"
        connection: false

    authors:
      - leka

    skills: []

    tags:
      - template

    interaction:
      medium: tablet
      input: touch_to_select

    types:
      - one_on_one

    locales:
      - en_US
      - fr_FR

    l10n:
      - locale: fr_FR
        details:
          icon: template_touch_to_select

          title: 0 - Touch To Select
          subtitle: 0 - Find The Right Answers

          short_description: |
            Lorem ipsum

          description: |
            Lorem ipsum

          instructions: |
            Lorem ipsum

      - locale: en_US
        details:
          icon: template_touch_to_select

          title: 0 - Touch To Select
          subtitle: 0 - Find The Right Answers

          short_description: |
            Lorem ipsum

          description: |
            Lorem ipsum

          instructions: |
            Lorem ipsum

    payload:
      options:
        shuffle_exercises: false
        shuffle_groups: false
      exercise_groups:
        - group:
            - instructions:
                - locale: en_US
                  value: Test instruction
              interface: touchToSelect
              gameplay: findTheRightAnswers
              payload:
                choices:
                  - value: 🍉
                    type: emoji
                    is_right_answer: true
                  - value: 🍌
                    type: emoji
    """

// MARK: - ActivityDecode

final class ActivityDecode: XCTestCase {
    func test_decodeFromYamlString() throws {
        let activity = Activity(yaml: kTestActivityMock)

        XCTAssertNotNil(activity)

        if let activity {
            XCTAssertEqual(activity.id, "F8C90919AF204155A170D3957BABE7D6")
            XCTAssertEqual(activity.name, "TestActivityMock")
        }
    }
}
