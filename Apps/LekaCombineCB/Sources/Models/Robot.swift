//
//  Robot.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 17/02/2023.
//
import CombineCoreBluetooth
import Foundation

class Robot: ObservableObject, Identifiable {

	internal var id: UUID

	var central: Central
	var blePeripheral: Peripheral

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

	//	@Published var isConnected = false

	let commands = CommandKit()

	init(central: Central, blePeripheral: Peripheral) {
		self.id = blePeripheral.id

		self.blePeripheral = blePeripheral
		self.central = central

		readRequestAll()

		//		listen(to: BLESpecs.Battery.Characteristics.level, in: BLESpecs.Battery.service)
		//		listen(to: BLESpecs.Monitoring.Characteristics.chargingStatus, in: BLESpecs.Monitoring.service)
	}

	// func onAdvertisingDataUpdated(advertisingData: AdvertisementData) {
	// 	guard let advData = AdvertisingData(advertisingData) else { return }

	// 	name = advData.name
	// 	battery = advData.battery
	// 	isCharging = advData.isCharging
	// 	osVersion = advData.osVersion
	// }

	func readRequestAll() {
		//		guard isConnected else { return }

		readManufacturer()
		readModelNumber()
		readSerialNumber()
		readOsVersion()
		readBatteryLevel()
		readChargingStatus()
		readMagicCardId()
		readMagicCardLanguage()

	}

	// func listen(to characteristicUUID: CBUUID, in serviceUUID: CBUUID) {
	// 	var char: CBCharacteristic?
	// 	blePeripheral.discoverCharacteristic(withUUID: characteristicUUID, inServiceWithUUID: serviceUUID)
	// 		.receive(on: DispatchQueue.main)
	// 		.sink(
	// 			receiveCompletion: { _ in },
	// 			receiveValue: { characteristic in
	// 				char = characteristic
	// 			}
	// 		)
	// 		.store(in: &central.cancellables)

	// 	guard let char = char else { return }

	// 	self.blePeripheral.listenForUpdates(on: char)
	// 		.receive(on: DispatchQueue.main)
	// 		.sink(
	// 			receiveCompletion: { _ in
	// 				// Do nothing
	// 			},
	// 			receiveValue: { data in
	// 				if let value = data?.first {
	// 					self.isCharging = (value == 0x01)
	// 				}
	// 			}
	// 		)
	// 		.store(in: &central.cancellables)
	// }

	func runReinforcer(_ reinforcer: UInt8) {
		//		guard isConnected else { return }

		commands.addMotivator(reinforcer)
		let data = Data(commands.getCommands())

		blePeripheral.writeValue(
			data,
			writeType: .withoutResponse,
			forCharacteristic: BLESpecs.Commands.Characteristics.tx,
			inService: BLESpecs.Commands.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { _ in
				// Do nothing
			}
		)
		.store(in: &central.cancellables)
	}

	//
	// MARK: - Specific read functions
	//

	func readManufacturer() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.DeviceInformation.Characteristics.manufacturer,
			inService: BLESpecs.DeviceInformation.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let data = data else { return }
				self.manufacturer = String(
					decoding: data, as: UTF8.self)
			}
		)
		.store(in: &central.cancellables)
	}

	func readModelNumber() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.DeviceInformation.Characteristics.modelNumber,
			inService: BLESpecs.DeviceInformation.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let data = data else { return }
				self.modelNumber = String(
					decoding: data, as: UTF8.self)
			}
		)
		.store(in: &central.cancellables)
	}

	func readSerialNumber() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.DeviceInformation.Characteristics.serialNumber,
			inService: BLESpecs.DeviceInformation.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let data = data else { return }
				self.serialNumber = String(
					decoding: data, as: UTF8.self)
			}
		)
		.store(in: &central.cancellables)
	}

	func readOsVersion() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.DeviceInformation.Characteristics.osVersion,
			inService: BLESpecs.DeviceInformation.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let data = data else { return }
				self.osVersion = String(
					decoding: data, as: UTF8.self)
			}
		)
		.store(in: &central.cancellables)
	}

	func readBatteryLevel() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.Battery.Characteristics.level, inService: BLESpecs.Battery.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let value = data?.first else { return }
				self.battery = Int(value)
			}
		)
		.store(in: &central.cancellables)
	}

	func readChargingStatus() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.Monitoring.Characteristics.chargingStatus,
			inService: BLESpecs.Monitoring.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let value = data?.first else { return }
				self.isCharging = (value == 0x01)
			}
		)
		.store(in: &central.cancellables)
	}

	func readMagicCardId() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.MagicCard.Characteristics.id, inService: BLESpecs.MagicCard.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let data = data else { return }
				self.magicCardId = Int(data[1])
			}
		)
		.store(in: &central.cancellables)
	}

	func readMagicCardLanguage() {
		blePeripheral.readValue(
			forCharacteristic: BLESpecs.MagicCard.Characteristics.language, inService: BLESpecs.MagicCard.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let value = data?.first else { return }
				self.magicCardLanguage = (value == 0x01 ? "FR" : "EN")
			}
		)
		.store(in: &central.cancellables)
	}
}
