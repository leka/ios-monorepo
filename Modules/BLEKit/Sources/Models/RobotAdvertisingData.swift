// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public struct RobotAdvertisingData {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(name: String?, serviceData: Data) {
        let serviceData = AdvertisingServiceData(data: serviceData)
        self.name = name?.nilWhenEmpty ?? "⚠️ NO NAME"
        self.osVersion = serviceData.osVersion
        self.battery = serviceData.battery
        self.isCharging = serviceData.isCharging
        self.isDeepSleeping = serviceData.isDeepSleeping
    }

    public init?(advertisementData: AdvertisementData) {
        guard let rawServiceData = advertisementData.serviceData,
              let robotServiceData = rawServiceData[BLESpecs.AdvertisingData.service]
        else {
            return nil
        }

        self.init(name: advertisementData.localName, serviceData: robotServiceData)
    }

    // MARK: Public

    // MARK: - Public variables

    public let name: String
    public let osVersion: String?
    public let battery: Int
    public let isCharging: Bool
    public let isDeepSleeping: Bool?
}
