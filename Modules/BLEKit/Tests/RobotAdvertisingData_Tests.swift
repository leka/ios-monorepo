// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import BLEKit

final class RobotAdvertisingData_Tests: XCTestCase {

    func test_shouldReturnNameWhenNameIsNotNil() {
        // Given

        // When
        let advertisingData = RobotAdvertisingData(name: "Leka Robot Name", serviceData: Data([0, 0, 0, 0, 0, 0]))

        // Then
        let expected = "Leka Robot Name"
        let actual = advertisingData.name
        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnNoNameWhenNameIsNil() {
        // Given

        // When
        let advertisingData = RobotAdvertisingData(name: nil, serviceData: Data([0, 0, 0, 0, 0, 0]))

        // Then
        let expected = "⚠️ NO NAME"
        let actual = advertisingData.name
        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnNoNameWhenNameIsEmpty() {
        // Given

        // When
        let advertisingData = RobotAdvertisingData(name: "", serviceData: Data([0, 0, 0, 0, 0, 0]))

        // Then
        let expected = "⚠️ NO NAME"
        let actual = advertisingData.name
        XCTAssertEqual(expected, actual)
    }
}
