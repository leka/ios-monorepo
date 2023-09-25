// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine

public class Robot {

    // MARK: - General

    public func stop() {
        print("🤖 STOP 🛑 - Everything")
    }

    public func reboot() {
        print("🤖 REBOOT 💫")
    }

    // MARK: - Motion

    public func move(_ direction: Direction, speed: Float) {
        print("🤖 MOVE \(direction) at \(speed)")
    }

    public func move(left speedLeft: Float, right speedRight: Float) {
        print("🤖 MOVE left motor at \(speedLeft) and right motor at \(speedRight)")
    }

    public func spin(_ rotation: Rotation, speed: Float) {
        print("🤖 SPIN \(rotation) at \(speed)")
    }

    public func stopMotion() {
        print("🤖 STOP 🛑 - Motion")
    }

    // MARK: - Lights

    public func shine(_ lights: Lights, color: Color) {
        print("🤖 SHINE \(lights) in \(color)")
    }

    public func blacken(_ lights: Lights) {
        print("🤖 BLACKEN \(lights)")
    }

    public func stopLights() {
        print("🤖 STOP 🛑 - Lights")
    }

    // MARK: - Reinforcers

    public func run(_ reinforcer: Reinforcer) {
        print("🤖 RUN reinforcer \(reinforcer)")
    }

    // MARK: - Magic Cards

    public func onMagicCard() -> AnyPublisher<MagicCard, Never> {
        Just(MagicCard.dice_roll)
            .eraseToAnyPublisher()
    }

}
