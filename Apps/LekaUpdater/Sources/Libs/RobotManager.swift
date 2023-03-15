//
//  File.swift
//  ios-leka_update
//
//  Created by Yann LOCATELLI on 22/09/2022.
//

import Foundation
import CoreBluetooth
import CryptoKit

class RobotManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    let os_version: String = Bundle.main.object(forInfoDictionaryKey: "os_version") as! String

    @Published var robots = [RobotModel]()
    @Published var robot_connected: RobotModel?

    var central: CBCentralManager!

    override init() {
        super.init()

        central = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            central.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])
        default:
            print("Unknown issue")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let adv_data = AdvertisingData(advertisementData) else {return}

        if let index = robots.firstIndex(where: {$0.peripheral == peripheral}) {
            robots[index].updateFrom(advertising_data: adv_data)
        } else {
            robots.append(RobotModel(peripheral: peripheral, advertising_data: adv_data))
        }
    }

    func connect(to robot: RobotModel) {
        robot_connected = robot

        central.stopScan()
        central.connect(robot_connected!.peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func disconnect() {
        if robot_connected == nil {
            return
        }

        central.cancelPeripheralConnection(robot_connected!.peripheral)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        robot_connected = nil

        central.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])

        sending_file_progression = 0.0
        errorMessage = ""
    }

    func readOSVersion() {
        if robot_connected == nil { return }

        guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.DeviceInformation.service}) else { return }
        guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.DeviceInformation.Characteristics.osVersion}) else { return }

        robot_connected!.peripheral.readValue(for: characteristic)
    }

    var applying_update_fail = false
    func applyUpdate() {
        if !isUpdateCanBeApplied() { return }

        applying_update_fail = false

        if robot_connected!.os_version!.compare("1.3.0", options: .numeric) != .orderedAscending {
            setRobotInFileExchangeState()
        }
        if robot_connected!.os_version!.compare("1.3.0", options: .numeric) == .orderedAscending {
            setDestinationPath() // Set path and clear for robot version before 1.3.0
        } else {
            setDestinationPath() // Set path only for robot version since 1.3.0
            setClearFile()
        }
        send()

    }

    @Published var errorMessage: String = ""
    func isUpdateCanBeApplied() -> Bool {
        errorMessage = ""
        if robot_connected == nil {
            errorMessage = "Robot not connected"
            return false
        }

        if robot_connected!.is_charging == false {
            errorMessage = "Robot not in charge"
            return false
        }
        if robot_connected!.battery < 30 {
            errorMessage = "Robot have not enough batteries"
            return false
        }

        return true
    }

    func setRobotInFileExchangeState() {
        guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
        guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.setState}) else { return }

        robot_connected!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
    }

    func setClearFile() {
        guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
        guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.clearFile}) else { return }

        robot_connected!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
    }

    func setDestinationPath() {
        let directory = "/fs/usr/os"
        let filename = "LekaOS-\(os_version).bin"
        let destination_path = directory + "/" + filename

        guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
        guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.filePath}) else { return }

        robot_connected!.peripheral.writeValue(destination_path.data(using: .utf8)!, for: characteristic, type: .withResponse)
    }

    @Published var sending_file_progression: Float = 0.0
    @Published var is_sending_file_and_not_charging: Bool = false
    @Published var sending_file_is_paused: Bool = false

    var timer: Timer?
    let maximum_packet_size: Int = 61 // 61 for one packet, 236 for max bytes in multiple packet

    var expected_complete_packets = 0
    var expected_remaining_bytes = 0

    var data = Data()
    var current_packet = 0
    var optimized_delay_in_seconds = 0.07

    func send() {
        if !loadFile() { return }

        expected_complete_packets = Int(floor(Double(data.count / maximum_packet_size)))
        expected_remaining_bytes = Int(data.count % maximum_packet_size)

        current_packet = 0
        sending_file_progression = 0.001

        timer = Timer.scheduledTimer(withTimeInterval: optimized_delay_in_seconds, repeats: true, block: onTick)
    }

    func loadFile() -> Bool {
        guard let fileURL = Bundle.main.url(forResource: "LekaOS-\(os_version)", withExtension: "bin") else {
            print("Failed to create URL for file.")
            return false
        }
        do {
            data = try Data(contentsOf: fileURL)
            return true
        } catch {
            print("Error opening file: \(error)")
            return false
        }
    }

    func onTick(timer: Timer) {
        is_sending_file_and_not_charging = !(robot_connected!.is_charging)

        func is_in_critical_section() -> Bool {
            let is_os_version_concerned = robot_connected!.os_version!.compare("1.3.0", options: .numeric) == .orderedAscending

            let is_not_charging = !(robot_connected!.is_charging)

            let battery_level = robot_connected!.battery
            let is_near_battery_level_change = 23...27 ~= battery_level || 48...52 ~= battery_level || 73...77 ~= battery_level || 88...92 ~= battery_level

            return is_os_version_concerned && (is_not_charging || is_near_battery_level_change)
        }
        sending_file_is_paused = is_in_critical_section()
        if sending_file_is_paused {
            return
        }

        if current_packet > expected_complete_packets {
            timer.invalidate()
            is_sending_file_and_not_charging = false
            Task {await onDataSent()}
        } else if current_packet < expected_complete_packets {
            sending_file_progression = Float(current_packet) / Float(expected_complete_packets)

            let start_index = 0 + current_packet * maximum_packet_size
            let end_index = (maximum_packet_size - 1) + current_packet * maximum_packet_size
            let data_to_send = data[start_index...end_index]

            guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
            guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.fileReceptionBuffer}) else { return }

            robot_connected!.peripheral.writeValue(data_to_send, for: characteristic, type: .withResponse)

        } else if current_packet == expected_complete_packets {
            sending_file_progression = Float(current_packet) / Float(expected_complete_packets)

            let start_index = expected_complete_packets * maximum_packet_size
            let end_index = expected_complete_packets * maximum_packet_size + expected_remaining_bytes - 1
            let data_to_send = data[start_index...end_index]

            guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
            guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.fileReceptionBuffer}) else { return }

            robot_connected!.peripheral.writeValue(data_to_send, for: characteristic, type: .withResponse)
        }

        current_packet += 1
    }

    var actual_sha256: String = ""
    func isSHA256Correct() async -> Bool {
        if robot_connected!.os_version!.compare("1.3.0", options: .numeric) != .orderedAscending {
            actual_sha256 = ""

            guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return false }
            guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.fileSHA256}) else { return false }

            robot_connected!.peripheral.readValue(for: characteristic)

            while actual_sha256.isEmpty || actual_sha256 == "0000000000000000000000000000000000000000000000000000000000000000" {
                do {
                    try await Task.sleep(seconds: 0.1)
                } catch {
                    // do nothing
                }
            }

            let expected_sha256: String = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
            return actual_sha256 == expected_sha256
        } else {
            return true
        }
    }

    func rebootRobot() {
        guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.Monitoring.service}) else { return }
        guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.Monitoring.Characteristics.softReboot}) else { return }
        robot_connected!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
    }

    func onDataSent() async {
        let is_not_sha256_correct = await !isSHA256Correct()
        if is_not_sha256_correct {
            rebootRobot()
            applying_update_fail = true
            sending_file_progression = 0.0
            return
        }

        let os_version_array = os_version.components(separatedBy: ".")

        let major: UInt8 = UInt8(os_version_array[0])!
        let minor: UInt8 = UInt8(os_version_array[1])!
        let revision: UInt16 = UInt16(os_version_array[2])!

        guard let service = robot_connected!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.service}) else { return }

        guard let characteristic_major = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.versionMajor}) else { return }
        robot_connected!.peripheral.writeValue(Data([major]), for: characteristic_major, type: .withResponse)

        guard let characteristic_minor = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.versionMinor}) else { return }
        robot_connected!.peripheral.writeValue(Data([minor]), for: characteristic_minor, type: .withResponse)

        guard let characteristic_revision = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.versionRevision}) else { return }
        robot_connected!.peripheral.writeValue(Data([UInt8(revision >> 8), UInt8(revision & 0x00FF)]), for: characteristic_revision, type: .withResponse)

        guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.requestUpdate}) else { return }
        robot_connected!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
    }
}

extension RobotManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if robot_connected == nil { return }
        guard let value = characteristic.value else { return }

        switch characteristic.uuid {
        case BLESpecs.Battery.Characteristics.level:
            if value.first != nil {
                robot_connected!.battery = value.first!
            }
        case BLESpecs.Monitoring.Characteristics.chargingStatus:
            if value.first != nil {
                robot_connected!.is_charging = (value.first == 0x01)
            }
        case BLESpecs.DeviceInformation.Characteristics.osVersion:
            if value.first != nil {
                robot_connected!.os_version = String(decoding: value, as: UTF8.self)
                    .replacingOccurrences(of: "\0", with: "")
            }
        case BLESpecs.FileExchange.Characteristics.fileSHA256:
            if value.first != nil {
                actual_sha256 = value.map { String(format: "%02hhx", $0) }.joined()
            }
        default:
            return
        }

        if robot_connected?.os_version == nil {
            readOSVersion()
        }
    }
}
