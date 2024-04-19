// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Foundation

class Robot: ObservableObject {
    // MARK: Internal

    @Published var manufacturer: String = ""
    @Published var modelNumber: String = ""
    @Published var serialNumber: String = ""
    @Published var osVersion: String = ""

    @Published var battery: Int = 0
    @Published var isCharging: Bool = false

    @Published var magicCardID: Int = 0
    @Published var magicCardLanguage: String = ""

    let commands = CommandKit()

    var robotPeripheral: RobotPeripheral? {
        didSet {
            self.updateDeviceInformation()
            self.subscribeToDeviceUpdates()
        }
    }

    func updateDeviceInformation() {
        guard let robotPeripheral else { return }

        self.registerReadOnlyCharacteristicClosures()

        robotPeripheral.readReadOnlyCharacteristics()
    }

    func subscribeToDeviceUpdates() {
        guard let robotPeripheral else { return }

        self.registerNotifyingCharacteristicClosures()

        robotPeripheral.discoverAndListenForUpdates()
    }

    func runReinforcer(_ reinforcer: UInt8) {
        guard let robotPeripheral else { return }

        self.commands.addMotivator(reinforcer)
        let data = Data(commands.getCommands())

        robotPeripheral.sendCommand(data)
    }

    // MARK: Private

    private func registerReadOnlyCharacteristicClosures() {
        for char in kDefaultReadOnlyCharacteristics {
            var newChar = char

            if newChar.characteristicUUID == BLESpecs.DeviceInformation.Characteristics.manufacturer {
                newChar.onNotification = {
                    [weak self] data in
                    if let data {
                        self?.manufacturer = String(
                            decoding: data, as: UTF8.self
                        )
                    }
                }
            }

            if newChar.characteristicUUID == BLESpecs.DeviceInformation.Characteristics.modelNumber {
                newChar.onNotification = {
                    [weak self] data in
                    if let data {
                        self?.modelNumber = String(
                            decoding: data, as: UTF8.self
                        )
                    }
                }
            }

            if newChar.characteristicUUID == BLESpecs.DeviceInformation.Characteristics.serialNumber {
                newChar.onNotification = {
                    [weak self] data in
                    if let data {
                        self?.serialNumber = String(
                            decoding: data, as: UTF8.self
                        )
                    }
                }
            }

            if newChar.characteristicUUID == BLESpecs.DeviceInformation.Characteristics.osVersion {
                newChar.onNotification = {
                    [weak self] data in
                    if let data {
                        self?.osVersion = String(
                            decoding: data, as: UTF8.self
                        )
                    }
                }
            }

            self.robotPeripheral?.readOnlyCharacteristics.insert(newChar)
        }
    }

    private func registerNotifyingCharacteristicClosures() {
        for char in kDefaultNotifyingCharacteristics {
            var newChar = char

            if newChar.characteristicUUID == BLESpecs.Battery.Characteristics.level {
                newChar.onNotification = {
                    [weak self] data in
                    if let value = data?.first {
                        self?.battery = Int(value)
                    }
                }
            }

            if newChar.characteristicUUID == BLESpecs.Monitoring.Characteristics.chargingStatus {
                newChar.onNotification = {
                    [weak self] data in
                    if let value = data?.first {
                        self?.isCharging = (value == 0x01)
                    }
                }
            }

            if newChar.characteristicUUID == BLESpecs.MagicCard.Characteristics.id {
                newChar.onNotification = {
                    [weak self] data in
                    if let data {
                        self?.magicCardID = Int(data[1])
                    }
                }
            }

            if newChar.characteristicUUID == BLESpecs.MagicCard.Characteristics.language {
                newChar.onNotification = {
                    [weak self] data in
                    if let value = data?.first {
                        self?.magicCardLanguage = (value == 0x01 ? "FR" : "EN")
                    }
                }
            }

            self.robotPeripheral?.notifyingCharacteristics.insert(newChar)
        }
    }
}
