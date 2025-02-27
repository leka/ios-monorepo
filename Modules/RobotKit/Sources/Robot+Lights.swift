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
        case randomBeltSpots(number: Int, in: [Color] = Color.allMainColors.shuffled())
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
            case randomBeltSpots(number: Int)
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
                default:
                    .black
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

                case let .randomBeltSpots(number, colors):
                    let availableSpotIDs: [UInt8] = [0, 3, 6, 9, 12, 15, 18].shuffled()
                    for (index, id) in Array(availableSpotIDs[0..<number]).enumerated() {
                        let payload = self.shineSpot(id, on: Spot.Position.belt, in: colors[index])
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
            case let .randomBeltSpots(number, _):
                self.shine(.randomBeltSpots(number: number, in: [.black]))
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
            case let .randomBeltSpots(number):
                self.shine(.randomBeltSpots(number: number, in: [.black]))
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
        let colors = Robot.Color.allMainColors
        let animationTime = 2.0

        Robot.shared.shine(.all(in: colors.randomElement()!))

        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
            self.stopLights()
        }
    }

    func flashLight(times: Int, timeInterval: Double = 0.5) {
        let colors = Robot.Color.allMainColors.shuffled()
        var animationTime = 0.1

        for i in 0..<times {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                Robot.shared.shine(.all(in: colors[i]))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime + timeInterval) {
                Robot.shared.blacken(.all)
            }
            animationTime += 1
        }
    }

    func cancelReinforcer() {
        self.timer?.cancel()
        self.timer = nil
    }

    func testDispatchTimer() {
        let totalDuration = 10.0 // Total simulation time in seconds
        let interval = 0.05 // 50ms interval (20 updates per second)
        let totalSteps = Int(totalDuration / interval)
        let cycleDuration = 2.0 // 2-second heartbeat cycle (slower)

        var currentStep = 0

        // Create a timer on a background queue
        self.timer?.cancel()
        self.timer = nil

        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInteractive))
        self.timer?.schedule(deadline: .now(), repeating: interval)

        self.timer?.setEventHandler {
            // Determine elapsed time and current time within the 2-second cycle
            let elapsedTime = Double(currentStep) * interval
            let cycleTime = elapsedTime.truncatingRemainder(dividingBy: cycleDuration)

            var brightness = 0.0

            // Primary pulse: ramp up from 0.0 to 0.3 sec and ramp down from 0.3 to 0.6 sec
            if cycleTime < 0.3 {
                brightness = cycleTime / 0.3
            } else if cycleTime < 0.6 {
                brightness = 1 - ((cycleTime - 0.3) / 0.3)
            }
            // Secondary pulse: ramp up from 0.6 to 0.9 sec and ramp down from 0.9 to 1.2 sec (at 70% intensity)
            else if cycleTime < 0.9 {
                brightness = ((cycleTime - 0.6) / 0.3) * 0.7
            } else if cycleTime < 1.2 {
                brightness = 0.7 * (1 - ((cycleTime - 0.9) / 0.3))
            } else {
                brightness = 0.0
            }

            // Convert brightness (0.0 to 1.0) to an 8-bit red value (0 to 255)
            let redValue = UInt8(brightness * 255)

            // Send the color to the BLE device using your Robot API
            Robot.shared.shine(.all(in: Robot.Color(r: redValue, g: 0, b: 0)))

            currentStep += 1
            if currentStep >= totalSteps {
                self.timer?.cancel()
            }
        }

        self.timer?.resume()
    }

    func beltBreath(for duration: Double, timeInterval: Double = 0.01) {
        let currentTime = DispatchTime.now()
        var timer = 0.0
        var paletteCursor = 0
        var breatheIn = true

        while timer < duration {
            log.debug("Dispatch after : \(currentTime + timer)")
            DispatchQueue.main.asyncAfter(deadline: currentTime + timer) {
                if paletteCursor >= 250 {
                    breatheIn = false
                } else if paletteCursor <= 5 {
                    breatheIn = true
                }
                paletteCursor += breatheIn ? 10 : -10
                Robot.shared.shine(.all(in: Robot.Color(r: UInt8(paletteCursor), g: 0, b: 0)))
            }
            timer += timeInterval
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.stopLights()
        }
    }

    func rotatingPoint(for duration: Double, timeInterval: Double = 0.01) {
        let currentTime = DispatchTime.now()
        var timer = 0.0
        var spotPosition = 0
        var turnClockwise = true

        while timer < duration {
            log.debug("Dispatch after : \(currentTime + timer)")
            DispatchQueue.main.asyncAfter(deadline: currentTime + timer) {
                if spotPosition >= 20 {
                    turnClockwise = false
                } else if spotPosition <= 0 {
                    turnClockwise = true
                }
                Robot.shared.blacken(.all)
                Robot.shared.shine(.spot(.belt, ids: [UInt8(spotPosition)], in: .red))
                spotPosition += turnClockwise ? 1 : -1
            }
            timer += timeInterval
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.stopLights()
        }
    }

    func spinBlink(for duration: Double) {
        let currentTime = DispatchTime.now()
        var timer = 0.0
        let timeInterval = 0.5
        var isGreen = true

        while timer < duration {
            log.debug("Dispatch after : \(currentTime + timer)")
            DispatchQueue.main.asyncAfter(deadline: currentTime + timer) {
                Robot.shared.shine(.all(in: isGreen ? .green : .mint))
                isGreen.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: currentTime + timer + timeInterval / 2.0) {
                Robot.shared.blacken(.all)
            }
            timer += timeInterval
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
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
