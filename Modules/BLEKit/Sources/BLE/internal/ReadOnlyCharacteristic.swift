//
//  ReadingCharacteristic.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 06/04/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import CombineCoreBluetooth
import Foundation

public struct ReadOnlyCharacteristic: Hashable {
	public let characteristicUUID: CBUUID
	public let serviceUUID: CBUUID
	public var onNotification: ((_ data: Data?) -> Void)?

	public func hash(into hasher: inout Hasher) {
		hasher.combine(characteristicUUID)
		hasher.combine(serviceUUID)
	}

	public static func == (lhs: ReadOnlyCharacteristic, rhs: ReadOnlyCharacteristic) -> Bool {
		return lhs.serviceUUID == rhs.serviceUUID && lhs.characteristicUUID == rhs.characteristicUUID
	}
}

public let kDefaultReadOnlyCharacteristics: Set<ReadOnlyCharacteristic> = [
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
