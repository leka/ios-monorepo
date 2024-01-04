// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import RobotKit

final class MagicCard_Tests: XCTestCase {
    func test_shouldBeLooselyEqualWhenLanguagesAreTheSame() {
        // Given

        // When
        let card1 = MagicCard(language: .fr_FR, id: 0xBEEF)
        let card2 = MagicCard(language: .fr_FR, id: 0xBEEF)

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldBeLooselyEqualWhenLanguagesAreNotTheSame() {
        // Given

        // When
        let card1 = MagicCard(language: .fr_FR, id: 0xBEEF)
        let card2 = MagicCard(language: .en_US, id: 0xBEEF)

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldBeStrictlyEqualWhenLanguagesAreTheSame() {
        // Given

        // When
        let card1 = MagicCard(language: .fr_FR, id: 0xBEEF)
        let card2 = MagicCard(language: .fr_FR, id: 0xBEEF)

        // Then
        XCTAssertTrue(card1 === card2)
    }

    func test_shouldNotBeStrictlyEqualWhenLanguagesAreNotTheSame() {
        // Given

        // When
        let card1 = MagicCard(language: .fr_FR, id: 0xBEEF)
        let card2 = MagicCard(language: .en_US, id: 0xBEEF)

        // Then
        XCTAssertFalse(card1 === card2)
    }

    func test_shouldBeLooselyEqualToAvailableCard() {
        // Given

        // When
        let card1 = MagicCard(id: 0x0002)
        let card2 = MagicCard.dice_roll

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldBeLooselyEqualWithDifferentLanguageToAvailableCard() {
        // Given

        // When
        let card1 = MagicCard(language: .fr_FR, id: 0x0002)
        let card2 = MagicCard.dice_roll

        // Then
        XCTAssertTrue(card1 == card2)
    }

    func test_shouldNotBeStrictlyEqualWithDifferentLanguageToAvailableCard() {
        // Given

        // When
        let card1 = MagicCard(language: .fr_FR, id: 0x0002)
        let card2 = MagicCard.dice_roll

        // Then
        XCTAssertFalse(card1 === card2)
    }
}
