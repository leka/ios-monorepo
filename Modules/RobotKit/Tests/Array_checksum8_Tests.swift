// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import RobotKit

final class Array_checksum8_Tests: XCTestCase {

    func test_checksum8ForOneValue0x00() {
        // Given
        let data: [UInt8] = [0x00]

        // When
        let checksum = data.checksum8

        // Then
        XCTAssertEqual(checksum, 0x00)
    }

    func test_checksum8ForOneValue0xFF() {
        // Given
        let data: [UInt8] = [0xFF]

        // When
        let checksum = data.checksum8

        // Then
        XCTAssertEqual(checksum, 0xFF)
    }

    func test_checksum8ForOneValueInfoCommand() {
        // Given
        let data: [UInt8] = [0x70]

        // When
        let checksum = data.checksum8

        // Then
        XCTAssertEqual(checksum, 0x70)
    }

    func test_checksum8ForTwoValues() {
        if true {
            // Given
            let data: [UInt8] = [0x00, 0xFF]

            // When
            let checksum = data.checksum8

            // Then
            XCTAssertEqual(checksum, 0xFF)
        }

        if true {
            // Given
            let data: [UInt8] = [0x01, 0xFF]

            // When
            let checksum = data.checksum8

            // Then
            XCTAssertEqual(checksum, 0x00)
        }

        if true {
            // Given
            let data: [UInt8] = [0xFF, 0x01]

            // When
            let checksum = data.checksum8

            // Then
            XCTAssertEqual(checksum, 0x00)
        }
    }

    func test_checksum8ForMultipleValuesTurnOneLedOn() {
        // Given
        let data: [UInt8] = [0x15, 0x00, 0xFF, 0x00, 0x00]

        // When
        let checksum = data.checksum8

        // Then
        XCTAssertEqual(checksum, 0x14)
    }

    func test_checksum8ForMultipleValuesTurnAllLedsOn() {
        // Given
        let data: [UInt8] = [
            0x15, 0x00, 0x33, 0x00, 0x00, 0x15, 0x01, 0x66, 0x00, 0x00, 0x15, 0x02, 0x99, 0x00, 0x00, 0x15, 0x03,
            0xCC, 0x00, 0x00, 0x15, 0x04, 0xFF, 0x00, 0x00, 0x15, 0x05, 0x00, 0x00, 0x00, 0x15, 0x06, 0x00, 0x33,
            0x00, 0x15, 0x07, 0x00, 0x66, 0x00, 0x15, 0x08, 0x00, 0x99, 0x00, 0x15, 0x09, 0x00, 0xCC, 0x00, 0x15,
            0x0A, 0x00, 0xFF, 0x00, 0x15, 0x0B, 0x00, 0x00, 0x00, 0x15, 0x0C, 0x00, 0x00, 0x33, 0x15, 0x0D, 0x00,
            0x00, 0x66, 0x15, 0x0E, 0x00, 0x00, 0x99, 0x15, 0x0F, 0x00, 0x00, 0xCC, 0x15, 0x10, 0xFF, 0x00, 0x00,
            0x15, 0x11, 0x00, 0xFF, 0x00, 0x15, 0x12, 0x00, 0x00, 0xFF, 0x15, 0x13, 0xFF, 0xFF, 0xFF,
        ]

        // When
        let checksum = data.checksum8

        // Then
        XCTAssertEqual(checksum, 0x54)
    }
}
