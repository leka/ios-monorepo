//
//  Robot.swift
//  LekaOS_BLE_Update
//
//  Created by Yann LOCATELLI on 29/08/2022.
//

import Foundation
import CoreBluetooth

struct RobotModel: Equatable {
	var peripheral: CBPeripheral

	var name: String
	var battery: UInt8
	var is_charging: Bool
	var os_version: String?

	init(peripheral: CBPeripheral, advertising_data adv_data: AdvertisingData) {
		self.peripheral = peripheral

		self.name = adv_data.name
		self.battery = adv_data.battery
		self.is_charging = adv_data.is_charging
		self.os_version = adv_data.os_version
	}

	mutating func updateFrom(advertising_data adv_data: AdvertisingData) {
		self.name = adv_data.name
		self.battery = adv_data.battery
		self.is_charging = adv_data.is_charging
		self.os_version = adv_data.os_version
	}
}
