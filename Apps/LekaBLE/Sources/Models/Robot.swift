//
//  Robot.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 17/02/2023.
//

import CoreBluetooth
import Foundation

class Robot: ObservableObject, Hashable, Identifiable {
	static func == (lhs: Robot, rhs: Robot) -> Bool {
		lhs.blePeripheral == rhs.blePeripheral
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(blePeripheral)
	}

	internal var id: UUID

	var blePeripheral: BLEPeripheral
	var isConnected: Bool {
		blePeripheral.isConnected
	}

	@Published var name = ""

	@Published var battery = 0
	@Published var isCharging = false
	@Published var osVersion = ""

	@Published var manufacturer = ""
	@Published var modelNumber = ""
	@Published var serialNumber = ""

	@Published var robotName = ""

	@Published var magicCardId = 0
	@Published var magicCardLanguage = ""

	@Published var fileExchangeState = false
	@Published var clearFile = false
	@Published var sha256 = ""

	let commands = CommandKit()

	init(blePeripheral: BLEPeripheral) {
		self.id = blePeripheral.id

		self.blePeripheral = blePeripheral
		self.blePeripheral.onValueUpdated = self.onValueUpdate
		self.blePeripheral.onAdvertisingDataUpdated = self.onAdvertisingDataUpdated
	}

	func onValueUpdate(uuid: CBUUID, data: Data) {
		guard let value = data.first else { return }

		switch uuid {
			case BLESpecs.Battery.Characteristics.level:
				battery = Int(value)
			case BLESpecs.Monitoring.Characteristics.chargingStatus:
				isCharging = (value == 0x01)
			case BLESpecs.DeviceInformation.Characteristics.osVersion:
				osVersion = String(decoding: data, as: UTF8.self).replacingOccurrences(of: "\0", with: "")
			case BLESpecs.DeviceInformation.Characteristics.manufacturer:
				manufacturer = String(decoding: data, as: UTF8.self)
			case BLESpecs.DeviceInformation.Characteristics.modelNumber:
				modelNumber = String(decoding: data, as: UTF8.self)
			case BLESpecs.DeviceInformation.Characteristics.serialNumber:
				serialNumber = String(decoding: data, as: UTF8.self)
			case BLESpecs.Config.Characteristics.robotName:
				robotName = String(decoding: data, as: UTF8.self)
			case BLESpecs.MagicCard.Characteristics.id:
				magicCardId = Int(data[1])
			case BLESpecs.MagicCard.Characteristics.language:
				magicCardLanguage = value == 0x01 ? "FR" : "EN"
			case BLESpecs.FileExchange.Characteristics.setState:
				fileExchangeState = (value == 0x01)
			case BLESpecs.FileExchange.Characteristics.clearFile:
				clearFile = (value == 0x01)
			case BLESpecs.FileExchange.Characteristics.fileSHA256:
				sha256 = data.map { String(format: "%02hhx", $0) }.joined()
			default:
				print("Unknown value updated (\(uuid.data.map { String(format: "%02hhx", $0) }.joined()))")
		}
	}

	func onAdvertisingDataUpdated(advertisingData: [String: Any]) {
		guard let advData = AdvertisingData(advertisingData) else { return }

		name = advData.name
		battery = advData.battery
		isCharging = advData.isCharging
		osVersion = advData.osVersion
	}

	func readRequestAll() {
		guard isConnected else { return }

		_ = blePeripheral.getValue(
			of: BLESpecs.DeviceInformation.Characteristics.manufacturer, in: BLESpecs.DeviceInformation.service)
		_ = blePeripheral.getValue(
			of: BLESpecs.DeviceInformation.Characteristics.modelNumber, in: BLESpecs.DeviceInformation.service)
		_ = blePeripheral.getValue(
			of: BLESpecs.DeviceInformation.Characteristics.serialNumber, in: BLESpecs.DeviceInformation.service)
		_ = blePeripheral.getValue(of: BLESpecs.Config.Characteristics.robotName, in: BLESpecs.Config.service)
	}

	func runReinforcer(_ reinforcer: UInt8) {
		guard isConnected else { return }

		commands.addMotivator(reinforcer)
		let data = Data(commands.getCommands())

		blePeripheral.setValue(of: BLESpecs.Commands.Characteristics.tx, in: BLESpecs.Commands.service, with: data)
	}
}
