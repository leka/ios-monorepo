// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation
import LogKit

let log = LogKit.createLoggerFor(module: "RobotKit")

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
        log.trace("🤖 STOP 🛑 - Everything")
    }

    public func reboot() {
        log.trace("🤖 REBOOT 💫")
    }

    // MARK: - Magic Cards

    public func onMagicCard() -> AnyPublisher<MagicCard, Never> {
        Just(MagicCard.dice_roll)
            .eraseToAnyPublisher()
    }

}
