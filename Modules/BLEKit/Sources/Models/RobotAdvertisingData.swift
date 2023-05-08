// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

extension String {

    public var nilWhenEmpty: String? {
        return self.isEmpty ? nil : self
    }

}

public struct RobotAdvertisingData: AdvertisingDataProcotol {

    // MARK: - Public variables

    public let name: String
    public let battery: Int
    public let isCharging: Bool
    public let osVersion: String

    // MARK: - Public functions

    public init(name: String?, serviceData: Data) {
        let serviceData = AdvertisingServiceData(data: serviceData)
        self.name = name?.nilWhenEmpty ?? "⚠️ NO NAME"
        self.battery = serviceData.battery
        self.isCharging = serviceData.isCharging
        self.osVersion = serviceData.osVersion
    }

    public init?(advertisementData: AdvertisementData) {
        guard
            let rawServiceData = advertisementData.serviceData,
            let robotServiceData = rawServiceData[BLESpecs.AdvertisingData.service]
        else {
            return nil
        }

        self.init(name: advertisementData.localName, serviceData: robotServiceData)
    }

}
