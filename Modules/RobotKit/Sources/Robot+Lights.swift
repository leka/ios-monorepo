// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable identifier_name

extension Robot {

    public enum Lights {

        public enum Position: UInt8 {
            case ears = 0x11
            case belt = 0x12
        }

        static let id: UInt8 = 0x10

        case belt
        case ears

        case halfLeft
        case halfRight
        case quarterFrontLeft
        case quarterFrontRight
        case quarterBackLeft
        case quarterBackRight

        case earLeft
        case earRight

        case spot(Position, ids: [UInt8])
        case range(start: Int, end: Int)

        static func spot(on position: Position, ids: UInt8...) -> Self {
            .spot(position, ids: ids)
        }

        static func range(startId: Int, endId: Int) -> Self {
            .range(start: startId, end: endId)
        }

        func cmd(color: Color) -> [[UInt8]] {
            var output: [[UInt8]] = [[]]

            switch self {
                case .spot(_: let position, let ids):
                    for id in ids {
                        let payload = shineSpot(id, in: color, on: position)
                        output.append(payload)
                    }

                default:
                    return [[]]
            }

            return output
        }

        private func shineSpot(_ id: UInt8, in color: Color, on position: Position) -> [UInt8] {
            var payload: [UInt8] = []

            payload.append(contentsOf: [
                position.rawValue,
                id,
            ])

            payload.append(contentsOf: color.data)
            payload.append(payload.checksum8)

            payload.insert(Self.id, at: 0)

            return payload
        }
    }

    public struct Color {

        public var data: [UInt8]

        public var red: UInt8 {
            data[0]
        }

        public var green: UInt8 {
            data[1]
        }

        public var blue: UInt8 {
            data[2]
        }

        // TODO(@hugo): Add all colors decided w/ Lucie, Hortense
        public static let red: Color = Color(data: [255, 0, 0])
        public static let green: Color = Color(data: [0, 255, 0])
        public static let blue: Color = Color(data: [0, 0, 255])

    }

    public func shine(_ lights: Lights, color: Color) {
        print("🤖 SHINE \(lights) in \(color)")

        let output = commandGenerator(commands: lights.cmd(color: color))

        connectedPeripheral?
            .sendCommand(output)

        dump(output)
    }

    public func blacken(_ lights: Lights) {
        print("🤖 BLACKEN \(lights)")
    }

    public func stopLights() {
        print("🤖 STOP 🛑 - Lights")
    }

}

// swiftlint:enable identifier_name
