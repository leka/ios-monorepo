// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import LekaUpdater

final class FileManager_Tests_compareVersion: XCTestCase {

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

}
