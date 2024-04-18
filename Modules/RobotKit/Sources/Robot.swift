// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation
import LogKit
import Version

let log = LogKit.createLoggerFor(module: "RobotKit")

// MARK: - Robot

public class Robot {
    // MARK: Lifecycle

    private init() {
        subscribeToBLEConnectionUpdates()
    }

    // MARK: Public

    public static var shared: Robot = .init()

    // MARK: - Information

    public var isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    public var name: CurrentValueSubject<String, Never> = CurrentValueSubject("(robot not connected)")
    public var osVersion: CurrentValueSubject<Version?, Never> = CurrentValueSubject(nil)
    public var serialNumber: CurrentValueSubject<String, Never> = CurrentValueSubject("(n/a)")
    public var isCharging: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    public var battery: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)

    // MARK: - Internal properties

    public var connectedPeripheral: RobotPeripheral? {
        didSet {
            registerBatteryCharacteristicNotificationCallback()
            registerChargingStatusNotificationCallback()

            registerOSVersionReadCallback()
            registerSerialNumberReadCallback()
            registerChargingStatusReadCallback()

            self.connectedPeripheral?.discoverAndListenForUpdates()
            self.connectedPeripheral?.readReadOnlyCharacteristics()
        }
    }

    // MARK: - General

    public func stop() {
        log.trace("🤖 STOP 🛑 - Everything")
        stopLights()
        stopMotion()
    }

    public func reboot() {
        log.trace("🤖 REBOOT 💫")
    }

    // MARK: - Magic Cards

    public func onMagicCard() -> AnyPublisher<MagicCard, Never> {
        Just(MagicCard.dice_roll)
            .eraseToAnyPublisher()
    }

    // MARK: Internal

    var cancellables: Set<AnyCancellable> = []
}
