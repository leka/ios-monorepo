// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// swiftlint:disable identifier_name nesting cyclomatic_complexity

public extension Robot {
    enum Lights {
        case all(in: Color)

        case full(_ position: Full.Position, in: Color)

        case halfLeft(in: Color)
        case halfRight(in: Color)
        case quarterFrontLeft(in: Color)
        case quarterFrontRight(in: Color)
        case quarterBackLeft(in: Color)
        case quarterBackRight(in: Color)

        case earLeft(in: Color)
        case earRight(in: Color)

        case spot(Spot.Position, ids: [UInt8], in: Color)
        case range(start: UInt8, end: UInt8, in: Color)

        // MARK: Public

        public enum Spot {
            // MARK: Public

            public enum Position: UInt8 {
                case ears = 0x11
                case belt = 0x12
            }

            // MARK: Internal

            static let id: UInt8 = 0x10
        }

        public enum Full {
            // MARK: Public

            public enum Position: UInt8 {
                case ears = 0x14
                case belt = 0x15
            }

            // MARK: Internal

            static let id: UInt8 = 0x13
        }

        public enum Range {
            // MARK: Public

            public enum Position: UInt8 {
                case ears = 0x17
                case belt = 0x18
            }

            // MARK: Internal

            static let id: UInt8 = 0x16
        }

        public enum Blacken {
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
        }

        public var color: Robot.Color {
            switch self {
                case let .all(color),
                     let .full(_, color),
                     let .halfLeft(color),
                     let .halfRight(color),
                     let .quarterFrontLeft(color),
                     let .quarterFrontRight(color),
                     let .quarterBackLeft(color),
                     let .quarterBackRight(color),
                     let .earLeft(color),
                     let .earRight(color),
                     let .spot(_, _, color),
                     let .range(_, _, color):
                    color
            }
        }

        // MARK: Internal

        var cmd: [[UInt8]] {
            var output: [[UInt8]] = [[]]

            switch self {
                case let .all(color):
                    let ears = self.shineFull(.ears, in: color)
                    let belt = self.shineFull(.belt, in: color)
                    output.append(contentsOf: [ears, belt])

                case let .spot(_: position, ids, color):
                    for id in ids {
                        let payload = self.shineSpot(id, on: position, in: color)
                        output.append(payload)
                    }

                case let .full(position, color):
                    let payload = self.shineFull(position, in: color)
                    output.append(payload)

                case let .range(start, end, color):
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .halfLeft(color):
                    let start: UInt8 = 0
                    let end: UInt8 = 9
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .halfRight(color):
                    let start: UInt8 = 10
                    let end: UInt8 = 19
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .quarterFrontLeft(color):
                    let start: UInt8 = 0
                    let end: UInt8 = 4
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .quarterFrontRight(color):
                    let start: UInt8 = 15
                    let end: UInt8 = 19
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .quarterBackLeft(color):
                    let start: UInt8 = 5
                    let end: UInt8 = 9
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .quarterBackRight(color):
                    let start: UInt8 = 10
                    let end: UInt8 = 14
                    let payload = self.shineRange(from: start, to: end, in: color)
                    output.append(payload)

                case let .earLeft(color):
                    let payload = self.shineSpot(0, on: .ears, in: color)
                    output.append(payload)

                case let .earRight(color):
                    let payload = self.shineSpot(1, on: .ears, in: color)
                    output.append(payload)
            }

            return output
        }

        static func spot(on position: Spot.Position, ids: UInt8..., in color: Color) -> Self {
            .spot(position, ids: ids, in: color)
        }

        static func range(startID: UInt8, endID: UInt8, in color: Color) -> Self {
            .range(start: startID, end: endID, in: color)
        }

        // MARK: Private

        private func shineSpot(_ id: UInt8, on position: Spot.Position, in color: Color) -> [UInt8] {
            var payload: [UInt8] = []

            payload.append(contentsOf: [
                position.rawValue,
                id,
            ])

            payload.append(contentsOf: color.robot)
            payload.append(payload.checksum8)

            payload.insert(Spot.id, at: 0)

            return payload
        }

        private func shineFull(_ position: Full.Position, in color: Color) -> [UInt8] {
            var payload: [UInt8] = []

            payload.append(contentsOf: [
                position.rawValue,
            ])

            payload.append(contentsOf: color.robot)
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

            payload.append(contentsOf: color.robot)
            payload.append(payload.checksum8)

            payload.insert(Range.id, at: 0)

            return payload
        }
    }

    func shine(_ lights: Lights) {
        log.trace("🤖 SHINE \(lights)")

        let output = Self.commandGenerator(commands: lights.cmd)

        connectedPeripheral?
            .sendCommand(output)
    }

    func blacken(_ lights: Lights) {
        log.trace("🤖 BLACKEN \(lights)")
        switch lights {
            case .all:
                self.shine(.all(in: .black))
            case let .full(position, _):
                self.shine(.full(position, in: .black))
            case .halfLeft:
                self.shine(.halfLeft(in: .black))
            case .halfRight:
                self.shine(.halfRight(in: .black))
            case .quarterFrontLeft:
                self.shine(.quarterFrontLeft(in: .black))
            case .quarterFrontRight:
                self.shine(.quarterFrontRight(in: .black))
            case .quarterBackLeft:
                self.shine(.quarterBackLeft(in: .black))
            case .quarterBackRight:
                self.shine(.quarterBackRight(in: .black))
            case .earLeft:
                self.shine(.earLeft(in: .black))
            case .earRight:
                self.shine(.earRight(in: .black))
            case let .spot(position, ids, _):
                self.shine(.spot(position, ids: ids, in: .black))
            case let .range(start, end, _):
                self.shine(.range(start: start, end: end, in: .black))
        }
    }

    func blacken(_ lights: Lights.Blacken) {
        log.trace("🤖 BLACKEN \(lights)")
        switch lights {
            case .all:
                self.shine(.all(in: .black))
            case let .full(position):
                self.shine(.full(position, in: .black))
            case .halfLeft:
                self.shine(.halfLeft(in: .black))
            case .halfRight:
                self.shine(.halfRight(in: .black))
            case .quarterFrontLeft:
                self.shine(.quarterFrontLeft(in: .black))
            case .quarterFrontRight:
                self.shine(.quarterFrontRight(in: .black))
            case .quarterBackLeft:
                self.shine(.quarterBackLeft(in: .black))
            case .quarterBackRight:
                self.shine(.quarterBackRight(in: .black))
            case .earLeft:
                self.shine(.earLeft(in: .black))
            case .earRight:
                self.shine(.earRight(in: .black))
            case let .spot(postion, ids):
                self.shine(.spot(postion, ids: ids, in: .black))
            case let .range(start, end):
                self.shine(.range(start: start, end: end, in: .black))
        }
    }

    func lightFrenzy() {
        let colors: [Robot.Color] = [.red, .blue, .green, .yellow, .lightBlue, .purple, .orange, .pink]
        var animationTime = 0.1

        while animationTime < 4.5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                Robot.shared.shine(self.getRandomLight(color: colors.randomElement()!))
            }
            animationTime += 0.2
        }
    }

    func randomLight() {
        let colors: [Robot.Color] = [.red, .blue, .green, .yellow, .lightBlue, .orange, .pink]
        let animationTime = 2.0

        Robot.shared.shine(.all(in: colors.randomElement()!))

        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            self.stopLights()
        }
    }

    private func getRandomLight(color: Robot.Color) -> Robot.Lights {
        let lights: [Robot.Lights] = [
            .earLeft(in: color), .earRight(in: color), .quarterBackLeft(in: color), .quarterBackRight(in: color),
            .quarterFrontLeft(in: color), .quarterFrontRight(in: color),
        ]
        return lights.randomElement()!
    }

    func stopLights() {
        log.trace("🤖 STOP 🛑 - Lights")
        self.shine(.all(in: .black))
    }
}

// swiftlint:enable identifier_name nesting cyclomatic_complexity
