// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
import Yams

@testable import ContentKit

let kTestActivityMock: String =
    """
    version: 1.0.0

    uuid: F8C90919AF204155A170D3957BABE7D6
    name: TestActivityMock

    created_at: "2024-06-17T17:38:12.804177"
    last_edited_at: "2024-09-10T23:15:58.558407"

    status: template

    authors:
      - leka

    skills: []

    tags:
      - template

    hmi:
      - tablet

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

    exercises_payload:
      key: "placeholder value for testing"
    """

// MARK: - ActivityDecode

final class ActivityDecode: XCTestCase {
    func test_decodeWithYAMLDecoder() throws {
        let activity = try YAMLDecoder().decode(NewActivity.self, from: kTestActivityMock)

        XCTAssertEqual(activity.id, "F8C90919AF204155A170D3957BABE7D6")
        XCTAssertEqual(activity.name, "TestActivityMock")
    }

    func test_decodeFromYamlString() throws {
        let activity = NewActivity(yaml: kTestActivityMock)

        XCTAssertNotNil(activity)

        if let activity {
            XCTAssertEqual(activity.id, "F8C90919AF204155A170D3957BABE7D6")
            XCTAssertEqual(activity.name, "TestActivityMock")
        }
    }
}
