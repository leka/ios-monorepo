// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - AdvertisingServiceData

struct AdvertisingServiceData {
    // MARK: Lifecycle

    init(data: Data) {
        self.battery = getBattery(data: data)
        self.isCharging = getChargingState(data: data)
        self.osVersion = getOsVersion(data: data)
    }

    // MARK: Internal

    let battery: Int
    let isCharging: Bool
    let osVersion: String?
}

// MARK: - AdvertisingServiceDataIndex

private enum AdvertisingServiceDataIndex {
    static let battery = 0
    static let isCharging = 1
    static let osVersionMajor = 2
    static let osVersionMinor = 3
    static let osVersionRevisionHighByte = 4
    static let osVersionRevisionLowByte = 5
}

private func getBattery(data: Data) -> Int {
    Int(data[AdvertisingServiceDataIndex.battery])
}

private func getChargingState(data: Data) -> Bool {
    data[AdvertisingServiceDataIndex.isCharging] == 0x01
}

private func getOsVersion(data: Data) -> String? {
    guard data.count == 6 else {
        return nil
    }

    let major = data[AdvertisingServiceDataIndex.osVersionMajor]
    let minor = data[AdvertisingServiceDataIndex.osVersionMinor]
    let revision =
        Int(data[AdvertisingServiceDataIndex.osVersionRevisionHighByte]) << 8
            + Int(data[AdvertisingServiceDataIndex.osVersionRevisionLowByte])

    return "\(major).\(minor).\(revision)"
}
