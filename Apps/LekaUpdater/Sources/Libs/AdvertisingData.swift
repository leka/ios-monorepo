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
        static let is_charging = 1
        static let os_version_major = 2
        static let os_version_minor = 3
        static let os_version_revision_high_byte = 4
        static let os_version_revision_low_byte = 5
    }

    var name: String
    var battery: UInt8
    var is_charging: Bool
    var os_version: String?

    init?(_ advertising_data: [String: Any]) {
        name = advertising_data["kCBAdvDataLocalName"] as! String

        guard let service_data = advertising_data[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] else {return nil}
        guard let leka_service_data = service_data[BLESpecs.AdvertisingData.service] else {return nil}

        battery = leka_service_data[Index.battery]
        is_charging = leka_service_data[Index.is_charging] == 0x01

        if leka_service_data.count == 6 {
            let os_version_major = leka_service_data[Index.os_version_major]
            let os_version_minor = leka_service_data[Index.os_version_minor]
            let os_version_revision = leka_service_data[Index.os_version_revision_high_byte] << 8 + leka_service_data[Index.os_version_revision_low_byte]

            os_version = "\(os_version_major).\(os_version_minor).\(os_version_revision)"
        }
    }
}
