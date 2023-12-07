// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Float {
    var isInRange0to1: Bool {
        self >= 0 && self <= 1
    }
}

public extension Robot {
    enum Motion {
        case stop
        case free(left: Float, right: Float)

        case forward(speed: Float)
        case forwardLeft(speed: Float)
        case forwardRight(speed: Float)
        case backward(speed: Float)
        case backwardLeft(speed: Float)
        case backwardRight(speed: Float)
        case spin(Rotation, speed: Float)

        // MARK: Public

        public enum Rotation: UInt8 {
            case clockwise = 0x00
            case counterclockwise = 0x01
        }

        // MARK: Internal

        enum Motor: UInt8 {
            case left = 0x21
            case right = 0x22
        }

        static let id: UInt8 = 0x20

        var cmd: [[UInt8]] {
            var output: [[UInt8]] = [[]]

            switch self {
                case .stop:
                    let payload = [
                        setMotor(.left, speed: 0, rotation: .clockwise),
                        setMotor(.right, speed: 0, rotation: .clockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .free(left, right):
                    let payload = [
                        setMotor(.left, speed: left, rotation: left < 0 ? .clockwise : .counterclockwise),
                        setMotor(.right, speed: right, rotation: right < 0 ? .clockwise : .counterclockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .forward(speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(.left, speed: speed, rotation: .counterclockwise),
                        setMotor(.right, speed: speed, rotation: .counterclockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .forwardLeft(speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(.left, speed: speed * 0.8, rotation: .counterclockwise),
                        setMotor(.right, speed: speed, rotation: .counterclockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .forwardRight(speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(.left, speed: speed, rotation: .counterclockwise),
                        setMotor(.right, speed: speed * 0.8, rotation: .counterclockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .backward(speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(.left, speed: speed, rotation: .clockwise),
                        setMotor(.right, speed: speed, rotation: .clockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .backwardLeft(speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(.left, speed: speed * 0.8, rotation: .clockwise),
                        setMotor(.right, speed: speed, rotation: .clockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .backwardRight(speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(.left, speed: speed, rotation: .clockwise),
                        setMotor(.right, speed: speed * 0.8, rotation: .clockwise),
                    ]
                    output.append(contentsOf: payload)

                case let .spin(rotation, speed):
                    guard speed.isInRange0to1 else { break }
                    let payload = [
                        setMotor(
                            .left, speed: speed, rotation: rotation == .clockwise ? .counterclockwise : .clockwise
                        ),
                        setMotor(
                            .right, speed: speed, rotation: rotation == .clockwise ? .clockwise : .counterclockwise
                        ),
                    ]
                    output.append(contentsOf: payload)
            }

            return output
        }

        // MARK: Private

        private func setMotor(_ motor: Motor, speed: Float, rotation: Rotation) -> [UInt8] {
            let speed = UInt8(abs(speed) * 255)

            var payload: [UInt8] = []

            payload.append(contentsOf: [
                motor.rawValue,
                rotation.rawValue,
                speed,
            ])

            payload.append(payload.checksum8)

            payload.insert(Motion.id, at: 0)

            return payload
        }
    }

    func move(_ motion: Motion) {
        log.trace("🤖 MOVE \(motion)")
        let output = Self.commandGenerator(commands: motion.cmd)

        connectedPeripheral?
            .sendCommand(output)
    }

    func stopMotion() {
        log.trace("🤖 STOP 🛑 - Motion")
        move(.stop)
    }
}
