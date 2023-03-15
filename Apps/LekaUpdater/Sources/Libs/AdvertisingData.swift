//
//  AdvertisingData.swift
//  LekaUpdater
//
//  Created by Yann LOCATELLI on 08/12/2022.
//

import Foundation
import CoreBluetooth

struct AdvertisingData {
	private struct Index {
		static let battery = 0
		static let isCharging = 1
		static let osVersionMajor = 2
		static let osVersionMinor = 3
		static let osVersionRevisionHighByte = 4
		static let osVersionRevisionLowByte = 5
	}

	var name: String
	var battery: UInt8
	var isCharging: Bool
	var osVersion: String?

	init?(_ advertisingData: [String: Any]) {
		name = advertisingData["kCBAdvDataLocalName"] as! String

		guard let serviceData = advertisingData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] else {return nil}
		guard let lekaServiceData = serviceData[BLESpecs.AdvertisingData.service] else {return nil}

		battery = lekaServiceData[Index.battery]
		isCharging = lekaServiceData[Index.isCharging] == 0x01

		if lekaServiceData.count == 6 {
			let osVersionMajor = lekaServiceData[Index.osVersionMajor]
			let osVersionMinor = lekaServiceData[Index.osVersionMinor]
			let osVersionRevision = lekaServiceData[Index.osVersionRevisionHighByte] << 8
				+ lekaServiceData[Index.osVersionRevisionLowByte]

			osVersion = "\(osVersionMajor).\(osVersionMinor).\(osVersionRevision)"
		}
	}
}
