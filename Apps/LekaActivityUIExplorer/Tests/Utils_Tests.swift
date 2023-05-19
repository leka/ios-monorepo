// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest

final class UtilsLeftPWMConversion_Tests: XCTestCase {
    let maxValue: CGFloat = 300

    func test_shouldReturnPWM_equals0_0() {
        // Given
        let posX: CGFloat = 0.0
        let posY: CGFloat = 0.0

        // When
        let actualLeftPWM = convertJoystickPosXToPWM(posX: posX, posY: posY, maxValue: maxValue)
        let actualRightPWM = convertJoystickPosYToPWM(posX: posX, posY: posY, maxValue: maxValue)

        // Then
        let expectedLeftMotor = 0.0
        let expectedRightMotor = 0.0

        XCTAssertEqual(expectedLeftMotor, actualLeftPWM)
        XCTAssertEqual(expectedRightMotor, actualRightPWM)
    }

    func test_shouldReturnPWM_equals255_255() {
        // Given
        let posX: CGFloat = 0.0
        let posY: CGFloat = -maxValue

        // When
        let actualLeftPWM = convertJoystickPosXToPWM(posX: posX, posY: posY, maxValue: maxValue)
        let actualRightPWM = convertJoystickPosYToPWM(posX: posX, posY: posY, maxValue: maxValue)

        // Then
        let expectedLeftMotor = 255.0
        let expectedRightMotor = 255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftPWM)
        XCTAssertEqual(expectedRightMotor, actualRightPWM)
    }

    func test_shouldReturnPWM_equalsMinus255_minus255() {
        // Given
        let posX: CGFloat = 0.0
        let posY: CGFloat = maxValue

        // When
        let actualLeftPWM = convertJoystickPosXToPWM(posX: posX, posY: posY, maxValue: maxValue)
        let actualRightPWM = convertJoystickPosYToPWM(posX: posX, posY: posY, maxValue: maxValue)

        // Then
        let expectedLeftMotor = -255.0
        let expectedRightMotor = -255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftPWM)
        XCTAssertEqual(expectedRightMotor, actualRightPWM)
    }

    func test_shouldReturnPWM_equals255_minus255() {
        // Given
        let posX: CGFloat = maxValue
        let posY: CGFloat = 0.0

        // When
        let actualLeftPWM = convertJoystickPosXToPWM(posX: posX, posY: posY, maxValue: maxValue)
        let actualRightPWM = convertJoystickPosYToPWM(posX: posX, posY: posY, maxValue: maxValue)

        // Then
        let expectedLeftMotor = 255.0
        let expectedRightMotor = -255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftPWM)
        XCTAssertEqual(expectedRightMotor, actualRightPWM)
    }

    func test_shouldReturnPWM_equalsMinus255_255() {
        // Given
        let posX: CGFloat = -maxValue
        let posY: CGFloat = 0.0

        // When
        let actualLeftPWM = convertJoystickPosXToPWM(posX: posX, posY: posY, maxValue: maxValue)
        let actualRightPWM = convertJoystickPosYToPWM(posX: posX, posY: posY, maxValue: maxValue)

        // Then
        let expectedLeftMotor = -255.0
        let expectedRightMotor = 255.0

        XCTAssertEqual(expectedLeftMotor, actualLeftPWM)
        XCTAssertEqual(expectedRightMotor, actualRightPWM)
    }
}
