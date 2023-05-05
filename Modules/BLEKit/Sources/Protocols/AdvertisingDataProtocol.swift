// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

protocol AdvertisingDataProcotol {

    var name: String { get }
    var osVersion: String { get }
    var battery: Int { get }
    var isCharging: Bool { get }

}
