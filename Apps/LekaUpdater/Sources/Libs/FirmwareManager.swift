// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

class FirmwareManager: ObservableObject {
    // swiftlint:disable:next force_cast
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "LEKA_OS_VERSION") as! String
}
