// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct RobotAdvertisingData {

    // MARK: - Private variables

    private let advertisementData: AdvertisementData
    private let serviceData: Data

    // MARK: - Public functions

    public init?(_ advertisementData: AdvertisementData) {
        guard
            let rawServiceData = advertisementData.serviceData,
            let robotServiceData = rawServiceData[BLESpecs.AdvertisingData.service]
        else {
            return nil
        }

        self.advertisementData = advertisementData
        self.serviceData = robotServiceData
    }

    // MARK: - Public variables

    public var name: String {
        return self.advertisementData.localName ?? "⚠️ NO NAME"
    }

    public var isCharging: Bool {
        return serviceData[Index.isCharging] == 0x01
    }

    public var battery: Int {
        return Int(serviceData[Index.battery])
    }

    public var osVersion: String {
        guard self.serviceData.count == 6 else {
            return "⚠️ NO OS VERSION"
        }

        let major = self.serviceData[Index.osVersionMajor]
        let minor = self.serviceData[Index.osVersionMinor]
        let revision =
            self.serviceData[Index.osVersionRevisionHighByte] << 8
            + self.serviceData[Index.osVersionRevisionLowByte]

        return "\(major).\(minor).\(revision)"
    }

    // MARK: - Misc.

    private enum Index {
        static let battery = 0
        static let isCharging = 1
        static let osVersionMajor = 2
        static let osVersionMinor = 3
        static let osVersionRevisionHighByte = 4
        static let osVersionRevisionLowByte = 5
    }

}
