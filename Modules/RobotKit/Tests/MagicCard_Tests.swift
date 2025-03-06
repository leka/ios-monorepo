// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import RobotKit

final class MagicCard_Tests: XCTestCase {
    func test_shouldBeLooselyEqualWhenLanguagesAreTheSame() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0xBEEF, language: .fr_FR)!
        let card2 = MagicCard.from(id: 0xBEEF, language: .fr_FR)!

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldBeLooselyEqualWhenLanguagesAreNotTheSame() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0xBEEF, language: .fr_FR)!
        let card2 = MagicCard.from(id: 0xBEEF, language: .en_US)!

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldBeStrictlyEqualWhenLanguagesAreTheSame() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0xBEEF, language: .fr_FR)!
        let card2 = MagicCard.from(id: 0xBEEF, language: .fr_FR)!

        // Then
        XCTAssertTrue(card1 === card2)
    }

    func test_shouldNotBeStrictlyEqualWhenLanguagesAreNotTheSame() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0xBEEF, language: .fr_FR)!
        let card2 = MagicCard.from(id: 0xBEEF, language: .en_US)!

        // Then
        XCTAssertFalse(card1 === card2)
    }

    func test_shouldBeLooselyEqualToAvailableCard() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0x0002)!
        let card2 = MagicCard(.dice_roll)

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldBeLooselyEqualWithDifferentLanguageToAvailableCard() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0x0002, language: .fr_FR)!
        let card2 = MagicCard(.dice_roll)

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldNotBeStrictlyEqualWithDifferentLanguageToAvailableCard() {
        // Given

        // When
        let card1 = MagicCard.from(id: 0x0002, language: .fr_FR)!
        let card2 = MagicCard(.dice_roll)

        // Then
        XCTAssertFalse(card1 === card2)
    }
}
