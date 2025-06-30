// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import RobotKit

// MARK: - MagicCard_Tests

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

    func test_NewMagicCardStructure() throws {
        let jsonData: Data = """
            [
            {"name": "dice"},
            {"name": "number_1"}
            ]
            """.data(using: .utf8)!

        let cards = try JSONDecoder().decode([NewMagicCard].self, from: jsonData)

        print(cards)
    }
}

// MARK: - NewMagicCard

struct NewMagicCard {
    // MARK: Lifecycle

    init(id _: UInt16, name _: String = "placeholder") {}

    // MARK: Internal

    let id: UInt16
    let name: String
}

extension NewMagicCard {
    static let dice = NewMagicCard(id: 0x0001, name: "dice")
    static let number1 = NewMagicCard(id: 0x0002, name: "number_1")

    // swiftlint:disable:next identifier_name
    static let all: [NewMagicCard] = [
        dice,
        number1,
    ]

    static func getID(for name: String) -> UInt16 {
        NewMagicCard.all.first { $0 == name }?.id ?? 0
    }

    static func getCard(by id: Int) -> NewMagicCard {
        NewMagicCard.all.first { $0 == id } ?? NewMagicCard.dice
    }
}

// MARK: Decodable

extension NewMagicCard: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.id = NewMagicCard.getID(for: self.name)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

// MARK: Equatable

extension NewMagicCard: Equatable {
    public static func == (lhs: NewMagicCard, rhs: NewMagicCard) -> Bool {
        lhs.id == rhs.id
    }

    public static func == (lhs: NewMagicCard, rhs: Int) -> Bool {
        lhs.id == UInt16(rhs)
    }

    public static func == (lhs: Int, rhs: NewMagicCard) -> Bool {
        UInt16(lhs) == rhs.id
    }

    public static func == (lhs: NewMagicCard, rhs: String) -> Bool {
        lhs.name == rhs
    }
}
