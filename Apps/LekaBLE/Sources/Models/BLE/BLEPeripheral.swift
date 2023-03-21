//
//  BLEPeripheral.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 17/03/2023.
//

import CoreBluetooth
import Foundation

class BLEPeripheral: NSObject, CBPeripheralDelegate, Identifiable {
	let id: UUID

	var peripheral: CBPeripheral?

	private var advertisingData: [String: Any] = [:]

	var onAdvertisingDataUpdated: (([String: Any]) -> Void)?
	var onValueUpdated: ((CBUUID, Data) -> Void)?

	var isConnected: Bool {
		guard let peripheral = self.peripheral else {
			return false
		}
		return peripheral.state == CBPeripheralState.connected
	}

	init(peripheral: CBPeripheral?) {
		self.peripheral = peripheral

		if peripheral != nil {
			self.id = peripheral!.identifier
		} else {
			self.id = UUID()
		}
	}

	func advertisingDataUpdate(_ advertisingData: [String: Any]) {
		self.advertisingData = advertisingData

		if let callback = onAdvertisingDataUpdated {
			callback(self.advertisingData)
		}
	}

	private func getServiceFrom(uuid serviceUuid: CBUUID, on peripheral: CBPeripheral) -> CBService? {
		return peripheral.services?.first(where: { $0.uuid == serviceUuid })
	}

	private func getCharacteristicFrom(uuid characteristicUuid: CBUUID, in service: CBService) -> CBCharacteristic? {
		return service.characteristics?.first(where: { $0.uuid == characteristicUuid })
	}

	private func readValue(for characteristic: CBCharacteristic, on peripheral: CBPeripheral) -> Data? {
		peripheral.readValue(for: characteristic)
		return characteristic.value
	}

	private func writeValue(for characteristic: CBCharacteristic, with data: Data, on peripheral: CBPeripheral) {
		peripheral.writeValue(data, for: characteristic, type: .withResponse)
	}

	func getValue(of characteristicUuid: CBUUID, in serviceUuid: CBUUID) -> Data? {
		guard let peripheral = self.peripheral else { return nil }

		guard let service = getServiceFrom(uuid: serviceUuid, on: peripheral) else { return nil }
		guard let characteristic = getCharacteristicFrom(uuid: characteristicUuid, in: service) else { return nil }

		return readValue(for: characteristic, on: peripheral)
	}

	func setValue(of characteristicUuid: CBUUID, in serviceUuid: CBUUID, with data: Data) {
		guard let peripheral = self.peripheral else { return }

		guard let service = getServiceFrom(uuid: serviceUuid, on: peripheral) else { return }
		guard let characteristic = getCharacteristicFrom(uuid: characteristicUuid, in: service) else { return }

		writeValue(for: characteristic, with: data, on: peripheral)
	}

	internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard let services = peripheral.services else { return }
		for service in services {
			peripheral.discoverCharacteristics(nil, for: service)
		}
	}

	internal func peripheral(
		_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?
	) {
		guard let characteristics = service.characteristics else { return }
		for characteristic in characteristics {
			peripheral.setNotifyValue(true, for: characteristic)
		}
	}

	internal func peripheral(
		_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?
	) {
		guard let value = characteristic.value else { return }
		if let callback = onValueUpdated {
			callback(characteristic.uuid, value)
		}
	}
}
