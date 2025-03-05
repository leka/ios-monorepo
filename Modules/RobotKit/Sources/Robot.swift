// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
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
        AnalyticsManager.setUserPropertyUserRobotIsConnected(value: false)
        subscribeToBLEConnectionUpdates()
    }

    // MARK: Public

    public static var shared: Robot = .init()
    public static let kLatestFirmwareVersion: Version = .init(tolerant: "2.0")!

    // MARK: - Information

    public var isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    public var name: CurrentValueSubject<String, Never> = CurrentValueSubject("(robot not connected)")
    public var osVersion: CurrentValueSubject<Version?, Never> = CurrentValueSubject(nil)
    public var serialNumber: CurrentValueSubject<String, Never> = CurrentValueSubject("(n/a)")
    public var isCharging: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    public var battery: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    public var negotiatedMTU: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)

    public var magicCard: CurrentValueSubject<MagicCard, Never> = CurrentValueSubject(MagicCard(.dice_roll))

    public var connectedPeripheral: RobotPeripheral? {
        didSet {
            registerBatteryCharacteristicNotificationCallback()
            registerChargingStatusNotificationCallback()
            registerNegotiatedMTUNotificationCallback()
            registerMagicCardsNotificationCallback()

            registerOSVersionReadCallback()
            registerSerialNumberReadCallback()
            registerChargingStatusReadCallback()
            registerNegotiatedMTUReadCallback()
            registerMagicCardsReadCallback()

            self.connectedPeripheral?.discoverAndListenForUpdates()
            self.connectedPeripheral?.readReadOnlyCharacteristics()
        }
    }

    public static func mock(name: String = "Mock Robot", serialNumber: String = "1234567890", osVersion: Version = .init(tolerant: "1.0")!, battery: Int = 100, isCharging: Bool = false) -> Robot {
        let robot = Robot()
        robot.name.send(name)
        robot.serialNumber.send(serialNumber)
        robot.osVersion.send(osVersion)
        robot.isConnected.send(true)
        robot.battery.send(battery)
        robot.isCharging.send(isCharging)
        return robot
    }

    // MARK: - General

    public func stop() {
        log.trace("🤖 STOP 🛑 - Everything")
        stopLights()
        stopMotion()
    }

    public func rename(in name: String) {
        let previousName = self.name.value
        let dataName = name.data(using: .utf8)!
        let robotNameCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.Config.Characteristics.robotName,
            serviceUUID: BLESpecs.Config.service,
            onWrite: {
                self.reboot()
            }
        )

        self.connectedPeripheral?.send(dataName, forCharacteristic: robotNameCharacteristic)

        AnalyticsManager.logEventRobotRename(
            previousName: previousName,
            newName: name,
            serialNumber: self.serialNumber.value,
            osVersion: self.osVersion.value?.description ?? "Unknown version",
            isCharging: self.isCharging.value,
            batteryLevel: self.battery.value
        )
    }

    public func reboot() {
        log.trace("🤖 REBOOT 💫")
        let data = Data([1])

        let rebootCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.Monitoring.Characteristics.hardReboot,
            serviceUUID: BLESpecs.Monitoring.service
        )

        self.connectedPeripheral?.send(data, forCharacteristic: rebootCharacteristic)
    }

    // MARK: - Magic Cards

    public func onMagicCard() -> AnyPublisher<MagicCard, Never> {
        Just(MagicCard(.dice_roll))
            .eraseToAnyPublisher()
    }

    // MARK: Internal

    var cancellables: Set<AnyCancellable> = []
}
