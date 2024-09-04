// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct AdvertisingServiceDataV100: AdvertisingServiceDataProtocol {
    // MARK: Lifecycle

    init(data: Data) {
        self.battery = self.getBattery(data: data)
        self.isCharging = self.getChargingState(data: data)
        self.osVersion = self.getOsVersion(data: data)
        self.isDeepSleeping = self.getDeepSleeping(data: data)
    }

    // MARK: Internal

    var battery: Int = 0
    var isCharging: Bool = false
    var osVersion: String?
    var isDeepSleeping: Bool?

    func getBattery(data: Data) -> Int {
        Int(data[AdvertisingServiceDataIndex.battery])
    }

    func getChargingState(data: Data) -> Bool {
        data[AdvertisingServiceDataIndex.isCharging] == 0x01
    }

    func getOsVersion(data _: Data) -> String? {
        nil
    }

    func getDeepSleeping(data _: Data) -> Bool? {
        nil
    }

    // MARK: Private

    private enum AdvertisingServiceDataIndex {
        static let battery = 0
        static let isCharging = 1
    }
}
