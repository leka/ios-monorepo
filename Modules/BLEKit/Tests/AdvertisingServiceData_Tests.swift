// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import BLEKit

final class AdvertisingServiceData_Tests_BatteryLevel: XCTestCase {

    func test_shouldReturnBatteryLevel_equals0() {
        // Given
        let data: Data = Data([0, 0, 0, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = 0
        let actual = serviceData.battery

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnBatteryLevel_equals50() {
        // Given
        let data: Data = Data([50, 0, 0, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = 50
        let actual = serviceData.battery

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnBatteryLevel_equals100() {
        // Given
        let data: Data = Data([100, 0, 0, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = 100
        let actual = serviceData.battery

        XCTAssertEqual(expected, actual)
    }

}

final class AdvertisingServiceData_Tests_ChargingStatus: XCTestCase {

    func test_shouldReturnChargingStatus_isCharging() {
        // Given
        let data: Data = Data([0, 1, 0, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = true
        let actual = serviceData.isCharging

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnChargingStatus_isNotCharging() {
        // Given
        let data: Data = Data([0, 0, 0, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = false
        let actual = serviceData.isCharging

        XCTAssertEqual(expected, actual)
    }

}

final class AdvertisingServiceData_Tests_OsVersion: XCTestCase {

    func test_shouldReturnOsVersion_0_0_0() {
        // Given
        let data: Data = Data([0, 0, 0, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = "0.0.0"
        let actual = serviceData.osVersion

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnOsVersion_1_0_0() {
        // Given
        let data: Data = Data([0, 0, 1, 0, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = "1.0.0"
        let actual = serviceData.osVersion

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnOsVersion_1_2_0() {
        // Given
        let data: Data = Data([0, 0, 1, 2, 0, 0])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = "1.2.0"
        let actual = serviceData.osVersion

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnOsVersion_1_2_3() {
        // Given
        let data: Data = Data([0, 0, 1, 2, 0, 3])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = "1.2.3"
        let actual = serviceData.osVersion

        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnOsVersion_1_2_300() {
        // Given
        let data: Data = Data([0, 0, 1, 2, 0x01, 0x2C])

        // When
        let serviceData = AdvertisingServiceData(data: data)

        // Then
        let expected = "1.2.300"
        let actual = serviceData.osVersion

        XCTAssertEqual(expected, actual)
    }

}
