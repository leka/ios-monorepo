// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct AdvertisingServiceDataV200: AdvertisingServiceDataProtocol {
    // MARK: Lifecycle

    init(data: Data) {
        self.osVersion = self.getOsVersion(data: data)
        self.battery = self.getBattery(data: data)
        self.isCharging = self.getChargingState(data: data)
        self.isDeepSleeping = self.getDeepSleeping(data: data)
    }

    // MARK: Internal

    var osVersion: String?
    var battery: Int = 0
    var isCharging: Bool = false
    var isDeepSleeping: Bool?

    func getOsVersion(data: Data) -> String? {
        let major = data[AdvertisingServiceDataIndex.osVersionMajor]
        let minor = data[AdvertisingServiceDataIndex.osVersionMinor]

        return "\(major).\(minor)"
    }

    func getBattery(data: Data) -> Int {
        Int(data[AdvertisingServiceDataIndex.battery])
    }

    func getChargingState(data: Data) -> Bool {
        data[AdvertisingServiceDataIndex.isCharging] == 0x01
    }

    func getDeepSleeping(data: Data) -> Bool? {
        data[AdvertisingServiceDataIndex.isDeepSleeping] == 0x01
    }

    // MARK: Private

    private enum AdvertisingServiceDataIndex {
        static let osVersionMajor = 0
        static let osVersionMinor = 1
        static let battery = 2
        static let isCharging = 3
        static let isDeepSleeping = 4
    }
}
