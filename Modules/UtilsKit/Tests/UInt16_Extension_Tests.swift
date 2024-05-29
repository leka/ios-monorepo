// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import UtilsKit

// MARK: - UInt16_Extension_Tests_Data

final class UInt16_Extension_Tests_Data: XCTestCase {
    func test_shouldReturnData() {
        // Given
        let value: UInt16 = 0xBEEF

        // When

        // Then
        let expected = Data([0xBE, 0xEF])
        let actual = value.data

        XCTAssertEqual(expected, actual)
    }
}

// MARK: - UInt16_Extension_Tests_highByte_lowByte

final class UInt16_Extension_Tests_highByte_lowByte: XCTestCase {
    func test_shouldReturnHighByte() {
        // Given
        let value: UInt16 = 0x4200

        // When

        // Then
        let expected: UInt8 = 0x42
        let actual = value.highByte

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnLowByte() {
        // Given
        let value: UInt16 = 0x0042

        // When

        // Then
        let expected: UInt8 = 0x42
        let actual = value.lowByte

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnHighByteAndLowByte() {
        // Given
        let value: UInt16 = 0xBEEF

        // When

        // Then
        let expectedHigh: UInt8 = 0xBE
        let actualHigh = value.highByte

        XCTAssertEqual(expectedHigh, actualHigh)

        let expectedLow: UInt8 = 0xEF
        let actualLow = value.lowByte

        XCTAssertEqual(expectedLow, actualLow)
    }
}
