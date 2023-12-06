// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import XCTest

@testable import RobotKit

final class Robot_Commands_Tests: XCTestCase {
    func test_generateFrameForOneCommand() {
        // Given
        let cmd: [UInt8] = [0x50, 0x51, 0x51]

        // When
        let output = Robot.commandGenerator(commands: cmd)
        let expected = Data([0x2A, 0x2A, 0x2A, 0x2A, 0x01, 0x50, 0x51, 0x51])

        // Then
        XCTAssertEqual(output, expected)
    }

    func test_generateFrameForMultipleCommands() {
        // Given
        let cmd1: [UInt8] = [0x50, 0x51, 0x51]
        let cmd2: [UInt8] = [0x60, 0x61, 0x61]
        let cmd3: [UInt8] = [0x70, 0x71, 0x71]

        // When
        let output = Robot.commandGenerator(commands: cmd1, cmd2, cmd3)
        let expected = Data([
            0x2A, 0x2A, 0x2A, 0x2A, 0x03,
            0x50, 0x51, 0x51,
            0x60, 0x61, 0x61,
            0x70, 0x71, 0x71,
        ])

        // Then
        XCTAssertEqual(output, expected)
    }
}
