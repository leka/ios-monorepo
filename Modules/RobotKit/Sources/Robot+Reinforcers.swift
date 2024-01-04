// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension Robot {
    enum Reinforcer: UInt8, CaseIterable {
        case rainbow = 0x51
        case fire = 0x52
        case sprinkles = 0x53
        case spinBlinkBlueViolet = 0x54
        case spinBlinkGreenOff = 0x55

        // MARK: Internal

        static let id: UInt8 = 0x50

        var cmd: [UInt8] {
            let output: [UInt8] = [
                Self.id,
                rawValue,
                [rawValue].checksum8,
            ]

            return output
        }
    }

    func run(_ reinforcer: Reinforcer) {
        log.trace("🤖 RUN reinforcer \(reinforcer)")

        let output = Self.commandGenerator(commands: reinforcer.cmd)

        connectedPeripheral?
            .sendCommand(output)
    }
}
