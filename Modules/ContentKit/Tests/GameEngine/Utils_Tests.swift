// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import ContentKit

final class UtilsLeftPWMConversion_Tests: XCTestCase {
    let maxValue: CGFloat = 300

    func test_shouldReturnRotations_equalsClockwise_still_still() {
        // Given
        let position = CGPoint(x: 0.0, y: 0.0)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 0
        let expectedRightSpeed: CGFloat = 0

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_clockwise255_clockwise255() {
        // Given
        let position = CGPoint(x: 0.0, y: -self.maxValue)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 1
        let expectedRightSpeed: CGFloat = 1

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_counterclockwise255_counterclockwise255() {
        // Given
        let position = CGPoint(x: 0.0, y: maxValue)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = -1
        let expectedRightSpeed: CGFloat = -1

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_clockwise255_counterclockwise255() {
        // Given
        let position = CGPoint(x: maxValue, y: 0.0)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 1
        let expectedRightSpeed: CGFloat = -1

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_counterclockwise255_clockwise255() {
        // Given
        let position = CGPoint(x: -self.maxValue, y: 0.0)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = -1
        let expectedRightSpeed: CGFloat = 1

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_clockwise127_clockwise127() {
        // Given
        let position = CGPoint(x: 0.0, y: -self.maxValue / 2)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 0.5
        let expectedRightSpeed: CGFloat = 0.5

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_counterclockwise127_counterclockwise127() {
        // Given
        let position = CGPoint(x: 0.0, y: maxValue / 2)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = -0.5
        let expectedRightSpeed: CGFloat = -0.5

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_clockwise127_counterclockwise127() {
        // Given
        let position = CGPoint(x: maxValue / 2, y: 0.0)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 0.5
        let expectedRightSpeed: CGFloat = -0.5

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equals_counterclockwise127_clockwise127() {
        // Given
        let position = CGPoint(x: -self.maxValue / 2, y: 0.0)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = -0.5
        let expectedRightSpeed: CGFloat = 0.5

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equalsClockwise_still_counterclockwise255() {
        // Given
        let position = CGPoint(x: maxValue / 2, y: maxValue / 2)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 0
        let expectedRightSpeed: CGFloat = -1

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equalsClockwise_clockwise255_still() {
        // Given
        let position = CGPoint(x: maxValue / 2, y: -self.maxValue / 2)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 1
        let expectedRightSpeed: CGFloat = 0

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equalsCounterclockwise_still_clockwise255() {
        // Given
        let position = CGPoint(x: -self.maxValue / 2, y: -self.maxValue / 2)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = 0
        let expectedRightSpeed: CGFloat = 1

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }

    func test_shouldReturnRotations_equalsCounterclockwise_counterclockwise255_still() {
        // Given
        let position = CGPoint(x: -self.maxValue / 2, y: self.maxValue / 2)

        // When
        let (actualLeftSpeed, actualRightSpeed) = convertJoystickPosToSpeed(
            position: position, maxValue: maxValue
        )

        // Then
        let expectedLeftSpeed: CGFloat = -1
        let expectedRightSpeed: CGFloat = 0

        XCTAssertEqual(expectedLeftSpeed, actualLeftSpeed)
        XCTAssertEqual(expectedRightSpeed, actualRightSpeed)
    }
}
