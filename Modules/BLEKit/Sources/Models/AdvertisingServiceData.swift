// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

internal struct AdvertisingServiceData {
    enum Index {
        static let battery = 0
        static let isCharging = 1
        static let osVersionMajor = 2
        static let osVersionMinor = 3
        static let osVersionRevisionHighByte = 4
        static let osVersionRevisionLowByte = 5
    }

    private let data: Data

    init(data: Data) {
        self.data = data
    }

    public var battery: Int {
        Int(data[Index.battery])
    }

    public var isCharging: Bool {
        data[Index.isCharging] == 0x01
    }

    public var osVersion: String? {
        guard data.count == 6 else {
            return nil
        }

        let major = data[Index.osVersionMajor]
        let minor = data[Index.osVersionMinor]
        let revision =
            Int(data[Index.osVersionRevisionHighByte]) << 8
            + Int(data[Index.osVersionRevisionLowByte])

        return "\(major).\(minor).\(revision)"
    }

}
