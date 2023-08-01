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

    public var major: UInt8 {
        UInt8(currentVersion.components(separatedBy: ".")[0])!
    }
    public var minor: UInt8 {
        UInt8(currentVersion.components(separatedBy: ".")[1])!
    }
    public var revision: UInt16 {
        UInt16(currentVersion.components(separatedBy: ".")[2])!
    }

    public var data = Data()

    func compareWith(version: String) -> RobotUpdateStatus {
        guard version.contains(".") else {
            return .needsUpdate
        }

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
