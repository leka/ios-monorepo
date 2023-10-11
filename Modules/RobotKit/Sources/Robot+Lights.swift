// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable identifier_name nesting cyclomatic_complexity

extension Robot {

    public enum Lights {

        public enum Spot {
            static let id: UInt8 = 0x10
            public enum Position: UInt8 {
                case ears = 0x11
                case belt = 0x12
            }
        }

        public enum Full {
            static let id: UInt8 = 0x13
            public enum Position: UInt8 {
                case ears = 0x14
                case belt = 0x15
            }
        }

        public enum Range {
            static let id: UInt8 = 0x16
            public enum Position: UInt8 {
                case ears = 0x17
                case belt = 0x18
            }
        }

        case all

        case full(_ position: Full.Position)

        case halfLeft
        case halfRight
        case quarterFrontLeft
        case quarterFrontRight
        case quarterBackLeft
        case quarterBackRight

        case earLeft
        case earRight

        case spot(Spot.Position, ids: [UInt8])
        case range(start: UInt8, end: UInt8)

        static func spot(on position: Spot.Position, ids: UInt8...) -> Self {
            .spot(position, ids: ids)
        }

        static func range(startId: UInt8, endId: UInt8) -> Self {
            .range(start: startId, end: endId)
        }

        func cmd(color: Color) -> [[UInt8]] {
            var output: [[UInt8]] = [[]]

            switch self {
                case .all:
                    let ears = shineFull(.ears, in: color)
                    let belt = shineFull(.belt, in: color)
                    output.append(contentsOf: [ears, belt])

                case .spot(_: let position, let ids):
                    for id in ids {
                        let payload = shineSpot(id, on: position, in: color)
                        output.append(payload)
                    }

                case .full(let position):
                    let payload = shineFull(position, in: color)
                    output.append(payload)

                case .range(let start, let end):
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .halfLeft:
                    let start: UInt8 = 0
                    let end: UInt8 = 9
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .halfRight:
                    let start: UInt8 = 10
                    let end: UInt8 = 19
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .quarterFrontLeft:
                    let start: UInt8 = 0
                    let end: UInt8 = 4
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .quarterFrontRight:
                    let start: UInt8 = 15
                    let end: UInt8 = 19
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .quarterBackLeft:
                    let start: UInt8 = 5
                    let end: UInt8 = 9
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .quarterBackRight:
                    let start: UInt8 = 10
                    let end: UInt8 = 14
                    let payload = shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case .earLeft:
                    let payload = shineSpot(0, on: .ears, in: color)
                    output.append(payload)

                case .earRight:
                    let payload = shineSpot(1, on: .ears, in: color)
                    output.append(payload)

            }

            return output
        }

        private func shineSpot(_ id: UInt8, on position: Spot.Position, in color: Color) -> [UInt8] {
            var payload: [UInt8] = []

            payload.append(contentsOf: [
                position.rawValue,
                id,
            ])

            payload.append(contentsOf: color.data)
            payload.append(payload.checksum8)

            payload.insert(Spot.id, at: 0)

            return payload
        }

        private func shineFull(_ position: Full.Position, in color: Color) -> [UInt8] {
            var payload: [UInt8] = []

            payload.append(contentsOf: [
                position.rawValue
            ])

            payload.append(contentsOf: color.data)
            payload.append(payload.checksum8)

            payload.insert(Full.id, at: 0)

            return payload
        }

        private func shineRange(from start: UInt8, to end: UInt8, in color: Color) -> [UInt8] {
            var payload: [UInt8] = []

            payload.append(contentsOf: [
                Range.Position.belt.rawValue,
                start,
                end,
            ])

            payload.append(contentsOf: color.data)
            payload.append(payload.checksum8)

            payload.insert(Range.id, at: 0)

            return payload
        }

    }

    public func shine(_ lights: Lights, color: Color) {
        print("🤖 SHINE \(lights) in \(color)")

        let output = commandGenerator(commands: lights.cmd(color: color))

        connectedPeripheral?
            .sendCommand(output)

        // TODO(@ladislas): remove when done
        dump(output)
    }

    public func blacken(_ lights: Lights) {
        print("🤖 BLACKEN \(lights)")
        shine(lights, color: .black)
    }

    public func stopLights() {
        print("🤖 STOP 🛑 - Lights")
        shine(.all, color: .black)
    }

}

// swiftlint:enable identifier_name nesting cyclomatic_complexity
