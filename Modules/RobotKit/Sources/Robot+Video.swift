// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import UtilsKit

public extension Robot {
    enum Video {
        static let id: UInt8 = 0x80
    }

    func display(imageID: UInt16) {
        log.trace("🤖 DISPLAY image id\(imageID)")

        var command: [UInt8] = []

        command.append(imageID.highByte)
        command.append(imageID.lowByte)
        command.append(command.checksum8)
        command.insert(Video.id, at: 0)

        let output = Self.commandGenerator(commands: command)

        connectedPeripheral?.sendCommand(output)
    }

    func displayDefaultWorkingFace() {
        self.display(imageID: 0x0047)
    }
}
