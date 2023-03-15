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
	var osVersion: String

	@Published var robots = [RobotModel]()
	@Published var connectedRobot: RobotModel?

	var central: CBCentralManager!

	override init() {
		guard let osVersion = Bundle.main.object(forInfoDictionaryKey: "os_version") as? String else {
			fatalError("LekaOS version not found in InfoPlist")
		}

		self.osVersion = osVersion

		super.init()

		self.central = CBCentralManager(delegate: self, queue: nil)
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
		guard let advData = AdvertisingData(advertisementData) else {return}

		if let index = robots.firstIndex(where: {$0.peripheral == peripheral}) {
			robots[index].updateFrom(advertisingData: advData)
		} else {
			robots.append(RobotModel(peripheral: peripheral, advertisingData: advData))
		}
	}

	func connect(to robot: RobotModel) {
		connectedRobot = robot

		central.stopScan()
		central.connect(connectedRobot!.peripheral)
	}

	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.delegate = self
		peripheral.discoverServices(nil)
	}

	func disconnect() {
		if connectedRobot == nil {
			return
		}

		central.cancelPeripheralConnection(connectedRobot!.peripheral)
	}

	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		connectedRobot = nil

		central.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])

		sendingFileProgression = 0.0
		errorMessage = ""
	}

	func readOSVersion() {
		if connectedRobot == nil { return }

		guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.DeviceInformation.service}) else { return }
		guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.DeviceInformation.Characteristics.osVersion}) else { return }

		connectedRobot!.peripheral.readValue(for: characteristic)
	}

	var applyingUpdateFail = false

	func applyUpdate() {
		if !isUpdateCanBeApplied() { return }

		applyingUpdateFail = false

		if connectedRobot!.osVersion!.compare("1.3.0", options: .numeric) != .orderedAscending {
			setRobotInFileExchangeState()
		}
		if connectedRobot!.osVersion!.compare("1.3.0", options: .numeric) == .orderedAscending {
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
		if connectedRobot == nil {
			errorMessage = "Robot not connected"
			return false
		}

		if connectedRobot!.isCharging == false {
			errorMessage = "Robot not in charge"
			return false
		}
		if connectedRobot!.battery < 30 {
			errorMessage = "Robot have not enough batteries"
			return false
		}

		return true
	}

	func setRobotInFileExchangeState() {
		guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
		guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.setState}) else { return }

		connectedRobot!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
	}

	func setClearFile() {
		guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
		guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.clearFile}) else { return }

		connectedRobot!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
	}

	func setDestinationPath() {
		let directory = "/fs/usr/os"
		let filename = "LekaOS-\(osVersion).bin"
		let destinationPath = directory + "/" + filename

		guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
		guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.filePath}) else { return }

		connectedRobot!.peripheral.writeValue(destinationPath.data(using: .utf8)!, for: characteristic, type: .withResponse)
	}

	@Published var sendingFileProgression: Float = 0.0
	@Published var isSendingFileAndNotCharging: Bool = false
	@Published var sendingFileIsPaused: Bool = false

	var timer: Timer?
	let maximumPacketSize: Int = 61 // 61 for one packet, 236 for max bytes in multiple packet

	var expectedCompletePackets = 0
	var expectedRemainingBytes = 0

	var data = Data()
	var currentPacket = 0
	var optimizedDelayInSeconds = 0.07

	func send() {
		if !loadFile() { return }

		expectedCompletePackets = Int(floor(Double(data.count / maximumPacketSize)))
		expectedRemainingBytes = Int(data.count % maximumPacketSize)

		currentPacket = 0
		sendingFileProgression = 0.001

		timer = Timer.scheduledTimer(withTimeInterval: optimizedDelayInSeconds, repeats: true, block: onTick)
	}

	func loadFile() -> Bool {
		guard let fileURL = Bundle.main.url(forResource: "LekaOS-\(osVersion)", withExtension: "bin") else {
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
		isSendingFileAndNotCharging = !(connectedRobot!.isCharging)

		func isBatteryLevelInCriticalSection() -> Bool {
			let isOsVersionConcerned = connectedRobot!.osVersion!.compare("1.3.0", options: .numeric) == .orderedAscending

			let isNotCharging = !(connectedRobot!.isCharging)

			let batteryLevel = connectedRobot!.battery
			let isNearBatteryLevelChange = 23...27 ~= batteryLevel || 48...52 ~= batteryLevel || 73...77 ~= batteryLevel || 88...92 ~= batteryLevel

			return isOsVersionConcerned && (isNotCharging || isNearBatteryLevelChange)
		}
		sendingFileIsPaused = isBatteryLevelInCriticalSection()
		if sendingFileIsPaused {
			return
		}

		if currentPacket > expectedCompletePackets {
			timer.invalidate()
			isSendingFileAndNotCharging = false
			Task {await onDataSent()}
		} else if currentPacket < expectedCompletePackets {
			sendingFileProgression = Float(currentPacket) / Float(expectedCompletePackets)

			let startIndex = 0 + currentPacket * maximumPacketSize
			let endIndex = (maximumPacketSize - 1) + currentPacket * maximumPacketSize
			let dataToSend = data[startIndex...endIndex]

			guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
			guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.fileReceptionBuffer}) else { return }

			connectedRobot!.peripheral.writeValue(dataToSend, for: characteristic, type: .withResponse)

		} else if currentPacket == expectedCompletePackets {
			sendingFileProgression = Float(currentPacket) / Float(expectedCompletePackets)

			let startIndex = expectedCompletePackets * maximumPacketSize
			let endIndex = expectedCompletePackets * maximumPacketSize + expectedRemainingBytes - 1
			let dataToSend = data[startIndex...endIndex]

			guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return }
			guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.fileReceptionBuffer}) else { return }

			connectedRobot!.peripheral.writeValue(dataToSend, for: characteristic, type: .withResponse)
		}

		currentPacket += 1
	}

	var actualSHA256: String = ""
	func isSHA256Correct() async -> Bool {
		if connectedRobot!.osVersion!.compare("1.3.0", options: .numeric) != .orderedAscending {
			actualSHA256 = ""

			guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FileExchange.service}) else { return false }
			guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FileExchange.Characteristics.fileSHA256}) else { return false }

			connectedRobot!.peripheral.readValue(for: characteristic)

			while actualSHA256.isEmpty || actualSHA256 == "0000000000000000000000000000000000000000000000000000000000000000" {
				do {
					try await Task.sleep(seconds: 0.1)
				} catch {
					// do nothing
				}
			}

			let expectedSHA256: String = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
			return actualSHA256 == expectedSHA256
		} else {
			return true
		}
	}

	func rebootRobot() {
		guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.Monitoring.service}) else { return }
		guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.Monitoring.Characteristics.softReboot}) else { return }
		connectedRobot!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
	}

	func onDataSent() async {
		let isNotSHA256Correct = await !isSHA256Correct()
		if isNotSHA256Correct {
			rebootRobot()
			applyingUpdateFail = true
			sendingFileProgression = 0.0
			return
		}

		let osVersionArray = osVersion.components(separatedBy: ".")

		let major: UInt8 = UInt8(osVersionArray[0])!
		let minor: UInt8 = UInt8(osVersionArray[1])!
		let revision: UInt16 = UInt16(osVersionArray[2])!

		guard let service = connectedRobot!.peripheral.services?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.service}) else { return }

		guard let characteristicMajor = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.versionMajor}) else { return }
		connectedRobot!.peripheral.writeValue(Data([major]), for: characteristicMajor, type: .withResponse)

		guard let characteristicMinor = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.versionMinor}) else { return }
		connectedRobot!.peripheral.writeValue(Data([minor]), for: characteristicMinor, type: .withResponse)

		guard let characteristicRevision = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.versionRevision}) else { return }
		connectedRobot!.peripheral.writeValue(Data([UInt8(revision >> 8), UInt8(revision & 0x00FF)]), for: characteristicRevision, type: .withResponse)

		guard let characteristic = service.characteristics?.first(where: {$0.uuid == BLESpecs.FirmwareUpdate.Characteristics.requestUpdate}) else { return }
		connectedRobot!.peripheral.writeValue(Data([1]), for: characteristic, type: .withResponse)
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
		if connectedRobot == nil { return }
		guard let value = characteristic.value else { return }

		switch characteristic.uuid {
		case BLESpecs.Battery.Characteristics.level:
			if value.first != nil {
				connectedRobot!.battery = value.first!
			}
		case BLESpecs.Monitoring.Characteristics.chargingStatus:
			if value.first != nil {
				connectedRobot!.isCharging = (value.first == 0x01)
			}
		case BLESpecs.DeviceInformation.Characteristics.osVersion:
			if value.first != nil {
				connectedRobot!.osVersion = String(decoding: value, as: UTF8.self)
					.replacingOccurrences(of: "\0", with: "")
			}
		case BLESpecs.FileExchange.Characteristics.fileSHA256:
			if value.first != nil {
				actualSHA256 = value.map { String(format: "%02hhx", $0) }.joined()
			}
		default:
			return
		}

		if connectedRobot?.osVersion == nil {
			readOSVersion()
		}
	}
}
