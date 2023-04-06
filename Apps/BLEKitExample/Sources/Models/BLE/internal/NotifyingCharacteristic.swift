//
//  NotifyingCharacteristic.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 06/04/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import CombineCoreBluetooth
import Foundation

struct NotifyingCharacteristic: Hashable {
	let characteristicUUID: CBUUID
	let serviceUUID: CBUUID
	var characteristic: CBCharacteristic?
	var onNotification: ((_ data: Data?) -> Void)?

	func hash(into hasher: inout Hasher) {
		hasher.combine(characteristicUUID)
		hasher.combine(serviceUUID)
	}

	static func == (lhs: NotifyingCharacteristic, rhs: NotifyingCharacteristic) -> Bool {
		return lhs.serviceUUID == rhs.serviceUUID && lhs.characteristicUUID == rhs.characteristicUUID
	}
}

var kDefaultNotifyingCharacteristics: Set<NotifyingCharacteristic> = [
	NotifyingCharacteristic(
		characteristicUUID: BLESpecs.Battery.Characteristics.level, serviceUUID: BLESpecs.Battery.service
	),
	NotifyingCharacteristic(
		characteristicUUID: BLESpecs.Monitoring.Characteristics.chargingStatus,
		serviceUUID: BLESpecs.Monitoring.service
	),
	NotifyingCharacteristic(
		characteristicUUID: BLESpecs.MagicCard.Characteristics.id, serviceUUID: BLESpecs.MagicCard.service
	),
	NotifyingCharacteristic(
		characteristicUUID: BLESpecs.MagicCard.Characteristics.language, serviceUUID: BLESpecs.MagicCard.service
	),
]
