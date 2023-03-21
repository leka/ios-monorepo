//
//  AdvertisingData.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 08/12/2022.
//
import CoreBluetooth
import Foundation

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
	var battery: Int
	var isCharging: Bool
	var osVersion: String

	init?(_ advertisingData: [String: Any]) {
		guard let name = advertisingData["kCBAdvDataLocalName"] as? String else { return nil }

		self.name = name

		guard let serviceData = advertisingData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] else {
			return nil
		}
		guard let lekaServiceData = serviceData[BLESpecs.AdvertisingData.service] else { return nil }

		battery = Int(lekaServiceData[Index.battery])
		isCharging = lekaServiceData[Index.isCharging] == 0x01

		osVersion = ""
		if lekaServiceData.count == 6 {
			let osVersionMajor = lekaServiceData[Index.osVersionMajor]
			let osVersionMinor = lekaServiceData[Index.osVersionMinor]
			let osVersionRevision =
			lekaServiceData[Index.osVersionRevisionHighByte] << 8
			+ lekaServiceData[Index.osVersionRevisionLowByte]

			osVersion = "\(osVersionMajor).\(osVersionMinor).\(osVersionRevision)"
		}
	}
}
