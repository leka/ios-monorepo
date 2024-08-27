// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - AdvertisingServiceData

struct AdvertisingServiceData {
    // MARK: Lifecycle

    init(data: Data) {
        let dataCount = data.count

        let currentAdvertisingServiceData: any AdvertisingServiceDataProtocol = switch dataCount {
            case 2:
                AdvertisingServiceDataV100(data: data)
            case 6:
                AdvertisingServiceDataV130(data: data)
            case 5:
                AdvertisingServiceDataV200(data: data)
            default:
                AdvertisingServiceDataV100(data: data)
        }

        self.osVersion = currentAdvertisingServiceData.osVersion
        self.battery = currentAdvertisingServiceData.battery
        self.isCharging = currentAdvertisingServiceData.isCharging
        self.isDeepSleeping = currentAdvertisingServiceData.isDeepSleeping
    }

    // MARK: Internal

    let osVersion: String?
    let battery: Int
    let isCharging: Bool
    let isDeepSleeping: Bool?
}
