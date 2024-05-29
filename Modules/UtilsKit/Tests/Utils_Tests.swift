// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import UtilsKit

// MARK: - Utils_Tests_clamp

final class Utils_Tests_clamp: XCTestCase {
    func test_shouldReturnInt1() {
        // Given
        let value = 2

        // When

        // Then
        let expected = 1
        let actual = clamp(value, lower: 0, upper: 1)

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnInt0() {
        // Given
        let value: Int = -1

        // When

        // Then
        let expected = 0
        let actual = clamp(value, lower: 0, upper: 1)

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnFloat314() {
        // Given
        let value: Float = 2 * 3.14

        // When

        // Then
        let expected: Float = 3.14
        let actual = clamp(value, lower: 0.0, upper: 3.14)

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnDouble00() {
        // Given
        let value: Double = -2 * 3.14

        // When

        // Then
        let expected = 0.0
        let actual = clamp(value, lower: 0.0, upper: 3.14)

        XCTAssertEqual(expected, actual)
    }
}

// MARK: - Utils_Tests_degreesToRadian

final class Utils_Tests_degreesToRadian: XCTestCase {
    func test_shouldReturn2PiRadians() {
        // Given
        let value = 360.0

        // When

        // Then
        let expected: Double = 2 * .pi
        let actual = degreesToRadian(degrees: value)

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnMinus2PiRadians() {
        // Given
        let value: Double = -360.0

        // When

        // Then
        let expected: Double = -2 * .pi
        let actual = degreesToRadian(degrees: value)

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnPiRadians() {
        // Given
        let value = 180.0

        // When

        // Then
        let expected: Double = .pi
        let actual = degreesToRadian(degrees: value)

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnHalfPiRadians() {
        // Given
        let value = 90.0

        // When

        // Then
        let expected: Double = .pi / 2
        let actual = degreesToRadian(degrees: value)

        XCTAssertEqual(expected, actual)
    }
}
