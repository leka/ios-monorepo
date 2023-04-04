//
//  Robot.swift
//  LekaCombineCB
//
//  Created by Yann LOCATELLI on 17/02/2023.
//
import CombineCoreBluetooth
import Foundation

class Robot: ObservableObject, Identifiable {

	internal var id: UUID

	var central: Central
	var blePeripheral: Peripheral
	var batteryCBCharacteristic: CBCharacteristic?
	var chargingStatusCBCharacteristic: CBCharacteristic?
	var tagIDCBCharacteristic: CBCharacteristic?
	var tagLanguageCBCharacteristic: CBCharacteristic?


	@Published var manufacturer = ""
	@Published var modelNumber = ""
	@Published var serialNumber = ""
	@Published var osVersion = ""

	@Published var battery = 0
	@Published var isCharging = false

	@Published var magicCardId = 0
	@Published var magicCardLanguage = ""

	let commands = CommandKit()

	init(central: Central, blePeripheral: Peripheral) {
		self.id = blePeripheral.id

		self.blePeripheral = blePeripheral
		self.central = central

		discover()
		readRequestAll()
	}

	func readRequestAll() {
		guard central.connectedPeripheral == blePeripheral else { return }

		readManufacturer()
		readModelNumber()
		readSerialNumber()
		readOsVersion()
	}

	func discover() {
		guard central.connectedPeripheral == blePeripheral else { return }

		discoverBatteryCBCharacteristic()
		discoverChargingStatusCBCharacteristic()
		discoverTagCBCharacteristics()
	}

	func runReinforcer(_ reinforcer: UInt8) {
		guard central.connectedPeripheral == blePeripheral else { return }

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
	// MARK: - Specific discover functions
	//

	func discoverBatteryCBCharacteristic() {
		blePeripheral.discoverCharacteristic(
			withUUID: BLESpecs.Battery.Characteristics.level, inServiceWithUUID: BLESpecs.Battery.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in },
			receiveValue: { characteristic in
				self.blePeripheral.setNotifyValue(true, for: characteristic)
					.assertNoFailure()
					.sink {
						self.batteryCBCharacteristic = characteristic
						self.listenBatteryCharacteristic()
					}
					.store(in: &self.central.cancellables)
			}
		)
		.store(in: &central.cancellables)
	}

	func discoverChargingStatusCBCharacteristic() {
		blePeripheral.discoverCharacteristic(
			withUUID: BLESpecs.Monitoring.Characteristics.chargingStatus, inServiceWithUUID: BLESpecs.Monitoring.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in },
			receiveValue: { characteristic in
				self.blePeripheral.setNotifyValue(true, for: characteristic)
					.assertNoFailure()
					.sink {
						self.chargingStatusCBCharacteristic = characteristic
						self.listenChargingStatusCharacteristic()
					}
					.store(in: &self.central.cancellables)
			}
		)
		.store(in: &central.cancellables)
	}

	func discoverTagCBCharacteristics() {
		blePeripheral.discoverCharacteristics(
			withUUIDs: [BLESpecs.MagicCard.Characteristics.id, BLESpecs.MagicCard.Characteristics.language],
			inServiceWithUUID: BLESpecs.MagicCard.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in },
			receiveValue: { characteristics in
				self.blePeripheral.setNotifyValue(true, for: characteristics[0])
					.assertNoFailure()
					.sink {
						self.tagIDCBCharacteristic = characteristics[0]
						self.listenTagIDCharacteristic()
					}
					.store(in: &self.central.cancellables)
				self.blePeripheral.setNotifyValue(true, for: characteristics[1])
					.assertNoFailure()
					.sink {
						self.tagLanguageCBCharacteristic = characteristics[1]
						self.listenTagLanguageCharacteristic()
					}
					.store(in: &self.central.cancellables)
			}
		)
		.store(in: &central.cancellables)
	}

	//
	// MARK: - Specific listen functions
	//

	func listenBatteryCharacteristic() {
		guard let batteryCBCharacteristic = batteryCBCharacteristic else { return }

		blePeripheral.listenForUpdates(on: batteryCBCharacteristic)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { _ in
				},
				receiveValue: { data in
					if let value = data?.first {
						self.battery = Int(value)
					}
				}
			)
			.store(in: &central.cancellables)
	}

	func listenChargingStatusCharacteristic() {
		guard let chargingStatusCBCharacteristic = chargingStatusCBCharacteristic else { return }

		blePeripheral.listenForUpdates(on: chargingStatusCBCharacteristic)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { _ in
				},
				receiveValue: { data in
					if let value = data?.first {
						self.isCharging = (value == 0x01)
					}
				}
			)
			.store(in: &central.cancellables)
	}

	func listenTagIDCharacteristic() {
		guard let tagIDCBCharacteristic = tagIDCBCharacteristic else { return }

		blePeripheral.listenForUpdates(on: tagIDCBCharacteristic)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { _ in
				},
				receiveValue: { data in
					if let data = data {
						self.magicCardId = Int(data[1])
					}
				}
			)
			.store(in: &central.cancellables)
	}

	func listenTagLanguageCharacteristic() {
		guard let tagLanguageCBCharacteristic = tagLanguageCBCharacteristic else { return }

		blePeripheral.listenForUpdates(on: tagLanguageCBCharacteristic)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { _ in
				},
				receiveValue: { data in
					if let value = data?.first {
						self.magicCardLanguage = (value == 0x01 ? "FR" : "EN")
					}
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
}
