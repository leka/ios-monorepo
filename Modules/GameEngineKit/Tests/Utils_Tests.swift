// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import GameEngineKit

final class UtilsLeftPWMConversion_Tests: XCTestCase {
    let maxValue: CGFloat = 300

    func test_shouldReturnRotations_equalsClockwise_still_still() {
        // Given
        let position = CGPoint(x: 0.0, y: 0.0)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .still
        let expectedRotationRight: Rotation = .still

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_clockwise255_clockwise255() {
        // Given
        let position = CGPoint(x: 0.0, y: -maxValue)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .clockwise(speed: 255)
        let expectedRotationRight: Rotation = .clockwise(speed: 255)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_counterclockwise255_counterclockwise255() {
        // Given
        let position = CGPoint(x: 0.0, y: maxValue)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .counterclockwise(speed: 255)
        let expectedRotationRight: Rotation = .counterclockwise(speed: 255)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_clockwise255_counterclockwise255() {
        // Given
        let position = CGPoint(x: maxValue, y: 0.0)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .clockwise(speed: 255)
        let expectedRotationRight: Rotation = .counterclockwise(speed: 255)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_counterclockwise255_clockwise255() {
        // Given
        let position = CGPoint(x: -maxValue, y: 0.0)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .counterclockwise(speed: 255)
        let expectedRotationRight: Rotation = .clockwise(speed: 255)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_clockwise127_clockwise127() {
        // Given
        let position = CGPoint(x: 0.0, y: -maxValue / 2)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .clockwise(speed: 127)
        let expectedRotationRight: Rotation = .clockwise(speed: 127)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_counterclockwise127_counterclockwise127() {
        // Given
        let position = CGPoint(x: 0.0, y: maxValue / 2)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .counterclockwise(speed: 127)
        let expectedRotationRight: Rotation = .counterclockwise(speed: 127)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_clockwise127_counterclockwise127() {
        // Given
        let position = CGPoint(x: maxValue / 2, y: 0.0)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .clockwise(speed: 127)
        let expectedRotationRight: Rotation = .counterclockwise(speed: 127)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equals_counterclockwise127_clockwise127() {
        // Given
        let position = CGPoint(x: -maxValue / 2, y: 0.0)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .counterclockwise(speed: 127)
        let expectedRotationRight: Rotation = .clockwise(speed: 127)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equalsClockwise_still_counterclockwise255() {
        // Given
        let position = CGPoint(x: maxValue / 2, y: maxValue / 2)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .still
        let expectedRotationRight: Rotation = .counterclockwise(speed: 255)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equalsClockwise_clockwise255_still() {
        // Given
        let position = CGPoint(x: maxValue / 2, y: -maxValue / 2)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .clockwise(speed: 255)
        let expectedRotationRight: Rotation = .still

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equalsCounterclockwise_still_clockwise255() {
        // Given
        let position = CGPoint(x: -maxValue / 2, y: -maxValue / 2)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .still
        let expectedRotationRight: Rotation = .clockwise(speed: 255)

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }

    func test_shouldReturnRotations_equalsCounterclockwise_counterclockwise255_still() {
        // Given
        let position = CGPoint(x: -maxValue / 2, y: maxValue / 2)

        // When
        let (actualRotationLeft, actualRotationRight) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedRotationLeft: Rotation = .counterclockwise(speed: 255)
        let expectedRotationRight: Rotation = .still

        XCTAssertEqual(expectedRotationLeft, actualRotationLeft)
        XCTAssertEqual(expectedRotationRight, actualRotationRight)
    }
}
