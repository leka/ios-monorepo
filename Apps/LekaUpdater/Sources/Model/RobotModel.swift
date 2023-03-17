//
//  Robot.swift
//  LekaOS_BLE_Update
//
//  Created by Yann LOCATELLI on 29/08/2022.
//

import CoreBluetooth
import Foundation

struct RobotModel: Equatable {
	var peripheral: CBPeripheral

	var name: String
	var battery: UInt8
	var isCharging: Bool
	var osVersion: String?

	init(peripheral: CBPeripheral, advertisingData advData: AdvertisingData) {
		self.peripheral = peripheral

		self.name = advData.name
		self.battery = advData.battery
		self.isCharging = advData.isCharging
		self.osVersion = advData.osVersion
	}

	mutating func updateFrom(advertisingData advData: AdvertisingData) {
		self.name = advData.name
		self.battery = advData.battery
		self.isCharging = advData.isCharging
		self.osVersion = advData.osVersion
	}
}
