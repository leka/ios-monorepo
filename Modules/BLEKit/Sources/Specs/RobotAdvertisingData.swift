// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct RobotAdvertisingData {

    private struct Index {
        static let battery = 0
        static let isCharging = 1
        static let osVersionMajor = 2
        static let osVersionMinor = 3
        static let osVersionRevisionHighByte = 4
        static let osVersionRevisionLowByte = 5
    }

    public var name: String
    public var battery: Int
    public var isCharging: Bool
    public var osVersion: String

    public init?(_ advertisingData: AdvertisementData) {
        guard let name = advertisingData.localName else { return nil }

        self.name = name

        guard let serviceData = advertisingData.serviceData else {
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
