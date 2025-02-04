// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension Robot {
    enum Behavior: UInt8, CaseIterable {
        case stop = 0x00
        case launching = 0x01
        case sleeping = 0x02
        case waiting = 0x03
        case blinkOnCharge = 0x04
        case lowBattery = 0x05
        case chargingEmpty = 0x06
        case chargingLow = 0x07
        case chargingMedium = 0x08
        case chargingHigh = 0x09
        case chargingFull = 0x0A
        case bleConnectionWithoutVideo = 0x0B
        case bleConnectionWithVideo = 0x0C
        case working = 0x0D
        case fileExchange = 0x0E
        case magicCardDetected = 0x0F
        case mediumLowBattery = 0x10

        // MARK: Internal

        static let id: UInt8 = 0x60

        var cmd: [UInt8] {
            let output: [UInt8] = [
                Self.id,
                rawValue,
                [rawValue].checksum8,
            ]

            return output
        }
    }

    func run(_ behavior: Behavior) {
        log.trace("🤖 RUN reinforcer \(behavior)")

        let output = Self.commandGenerator(commands: behavior.cmd)

        connectedPeripheral?
            .sendCommand(output)
    }
}
