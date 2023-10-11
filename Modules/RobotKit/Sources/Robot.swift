// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation

public class Robot {

    public static var shared: Robot = Robot()

    // MARK: - Internal properties

    var connectedPeripheral: RobotPeripheral? {
        didSet {
            registerBatteryCharacteristicNotificationCallback()
            registerChargingStatusNotificationCallback()
            registerOSVersionReadCallback()
            registerSerialNumberReadCallback()

            connectedPeripheral?.discoverAndListenForUpdates()
            connectedPeripheral?.readReadOnlyCharacteristics()
        }
    }

    var cancellables: Set<AnyCancellable> = []

    private init() {
        subscribeToBLEConnectionUpdates()
    }

    // MARK: - Information

    public var isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    public var name: CurrentValueSubject<String, Never> = CurrentValueSubject("(robot not connected)")
    public var osVersion: CurrentValueSubject<String, Never> = CurrentValueSubject("(n/a)")
    public var serialNumber: CurrentValueSubject<String, Never> = CurrentValueSubject("(n/a)")
    public var isCharging: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    public var battery: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)

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

    // MARK: - Magic Cards

    public func onMagicCard() -> AnyPublisher<MagicCard, Never> {
        Just(MagicCard.dice_roll)
            .eraseToAnyPublisher()
    }

}
