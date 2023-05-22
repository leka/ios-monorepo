// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

@testable import LekaActivityUIExplorer

final class UtilsLeftPWMConversion_Tests: XCTestCase {
    let maxValue: CGFloat = 300

    func test_shouldReturnPWM_equals0_0() {
        // Given
        let position = CGPoint(x: 0.0, y: 0.0)

        // When
        let (actualLeftMotor, actualRightMotor) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedLeftMotor: Float = 0.0
        let expectedRightMotor: Float = 0.0

        XCTAssertEqual(expectedLeftMotor, actualLeftMotor)
        XCTAssertEqual(expectedRightMotor, actualRightMotor)
    }

    func test_shouldReturnPWM_equals255_255() {
        // Given
        let position = CGPoint(x: 0.0, y: -maxValue)

        // When
        let (actualLeftMotor, actualRightMotor) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedLeftMotor: Float = 255.0
        let expectedRightMotor: Float = 255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftMotor)
        XCTAssertEqual(expectedRightMotor, actualRightMotor)
    }

    func test_shouldReturnPWM_equalsMinus255_minus255() {
        // Given
        let position = CGPoint(x: 0.0, y: maxValue)

        // When
        let (actualLeftMotor, actualRightMotor) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedLeftMotor: Float = -255.0
        let expectedRightMotor: Float = -255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftMotor)
        XCTAssertEqual(expectedRightMotor, actualRightMotor)
    }

    func test_shouldReturnPWM_equals255_minus255() {
        // Given
        let position = CGPoint(x: maxValue, y: 0.0)

        // When
        let (actualLeftMotor, actualRightMotor) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedLeftMotor: Float = 255.0
        let expectedRightMotor: Float = -255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftMotor)
        XCTAssertEqual(expectedRightMotor, actualRightMotor)
    }

    func test_shouldReturnPWM_equalsMinus255_255() {
        // Given
        let position = CGPoint(x: -maxValue, y: 0.0)

        // When
        let (actualLeftMotor, actualRightMotor) = convertJoystickPosToMotorSpeed(
            position: position, maxValue: maxValue)

        // Then
        let expectedLeftMotor: Float = -255.0
        let expectedRightMotor: Float = 255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftMotor)
        XCTAssertEqual(expectedRightMotor, actualRightMotor)
    }
}
