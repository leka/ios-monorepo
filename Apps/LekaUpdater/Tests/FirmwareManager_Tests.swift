// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import LekaUpdater

final class FirmwareManager_Tests_compareVersion: XCTestCase {

    func test_shouldReturnRobotNeedUpdate_lowerVersion() {
        let firmwareManager = FirmwareManager()
        let robotVersion = "1.0.0"

        let expected = RobotUpdateStatus.needsUpdate
        let actual = firmwareManager.compareWith(version: robotVersion)
        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnRobotIsUpToDate_sameVersion() {
        let firmwareManager = FirmwareManager()
        let robotVersion = firmwareManager.currentVersion

        let expected = RobotUpdateStatus.upToDate
        let actual = firmwareManager.compareWith(version: robotVersion)
        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnRobotIsUpToDate_higherVersion() {
        let firmwareManager = FirmwareManager()
        let robotVersion = "99.99.999"

        let expected = RobotUpdateStatus.upToDate
        let actual = firmwareManager.compareWith(version: robotVersion)
        XCTAssertEqual(expected, actual)
    }

    func test_shouldReturnRobotNeedUpdate_invalidVersion() {
        let firmwareManager = FirmwareManager()
        let robotVersion = "⚠️ NO OS VERSION"

        let expected = RobotUpdateStatus.needsUpdate
        let actual = firmwareManager.compareWith(version: robotVersion)
        XCTAssertEqual(expected, actual)
    }

}

final class FirmwareManager_Tests_sha256: XCTestCase {

    func test_shouldReturnRobotNeedUpdate_invalidVersion() {
        let firmwareManager = FirmwareManager()
        _ = firmwareManager.load()

        let expectedSHA256 = "e061ee13041fe73667e4e9ca8f84189fb4cbc8f3d8710f8841fb41cf0df9e1e1"  // shasum -a 256 LekaOS-1.4.0.bin
        let actualSHA256 = firmwareManager.sha256

        XCTAssertEqual(expectedSHA256, actualSHA256)
    }

}
