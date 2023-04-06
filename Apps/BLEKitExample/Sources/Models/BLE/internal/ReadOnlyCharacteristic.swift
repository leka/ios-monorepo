//
//  ReadingCharacteristic.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 06/04/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import CombineCoreBluetooth
import Foundation

struct ReadOnlyCharacteristic: Hashable {
	let characteristicUUID: CBUUID
	let serviceUUID: CBUUID
	var onNotification: ((_ data: Data?) -> Void)?

	func hash(into hasher: inout Hasher) {
		hasher.combine(characteristicUUID)
		hasher.combine(serviceUUID)
	}

	static func == (lhs: ReadOnlyCharacteristic, rhs: ReadOnlyCharacteristic) -> Bool {
		return lhs.serviceUUID == rhs.serviceUUID && lhs.characteristicUUID == rhs.characteristicUUID
	}
}

var kDefaultReadOnlyCharacteristics: Set<ReadOnlyCharacteristic> = [
	ReadOnlyCharacteristic(
		characteristicUUID: BLESpecs.DeviceInformation.Characteristics.manufacturer,
		serviceUUID: BLESpecs.DeviceInformation.service
	),
	ReadOnlyCharacteristic(
		characteristicUUID: BLESpecs.DeviceInformation.Characteristics.modelNumber,
		serviceUUID: BLESpecs.DeviceInformation.service
	),
	ReadOnlyCharacteristic(
		characteristicUUID: BLESpecs.DeviceInformation.Characteristics.serialNumber,
		serviceUUID: BLESpecs.DeviceInformation.service
	),
	ReadOnlyCharacteristic(
		characteristicUUID: BLESpecs.DeviceInformation.Characteristics.osVersion,
		serviceUUID: BLESpecs.DeviceInformation.service
	),
]
