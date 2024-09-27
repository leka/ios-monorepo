// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

protocol AdvertisingServiceDataProtocol {
    var osVersion: String? { get }
    var battery: Int { get }
    var isCharging: Bool { get }
    var isDeepSleeping: Bool? { get }

    func getOsVersion(data: Data) -> String?
    func getBattery(data: Data) -> Int
    func getChargingState(data: Data) -> Bool
    func getDeepSleeping(data: Data) -> Bool?
}
