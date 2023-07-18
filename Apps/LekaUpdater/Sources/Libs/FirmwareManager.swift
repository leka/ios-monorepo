// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

enum RobotUpdateStatus {
    case upToDate
    case needsUpdate
}

class FirmwareManager: ObservableObject {
    // swiftlint:disable:next force_cast
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "LEKA_OS_VERSION") as! String

    public var data = Data()

    func compareWith(version: String) -> RobotUpdateStatus {
        guard version.compare(currentVersion, options: .numeric) == .orderedAscending else {
            return .upToDate
        }
        return .needsUpdate
    }

    public func load() -> Bool {
        guard let fileURL = Bundle.main.url(forResource: "LekaOS-\(currentVersion)", withExtension: "bin") else {
            return false
        }

        do {
            data = try Data(contentsOf: fileURL)
            return true
        } catch {
            return false
        }
    }
}
