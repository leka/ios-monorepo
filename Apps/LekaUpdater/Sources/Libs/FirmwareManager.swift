// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import CryptoKit
import Foundation
import RobotKit
import Version

// MARK: - RobotUpdateStatus

enum RobotUpdateStatus {
    case upToDate
    case needsUpdate
}

// MARK: - FirmwareManager

class FirmwareManager {
    // MARK: Public

    public var data = CurrentValueSubject<Data, Never>(Data())

    public var currentVersion = Robot.kLatestFirmwareVersion

    public var major: UInt8 {
        UInt8(self.currentVersion.major)
    }

    public var minor: UInt8 {
        UInt8(self.currentVersion.minor)
    }

    public var revision: UInt16 {
        UInt16(self.currentVersion.patch)
    }

    public var sha256: String {
        SHA256.hash(data: self.data.value).compactMap { String(format: "%02x", $0) }.joined()
    }

    public func load() -> Bool {
        guard let fileURL = Bundle.main.url(forResource: "LekaOS-\(currentVersion)", withExtension: "bin") else {
            return false
        }

        do {
            self.data.value = try Data(contentsOf: fileURL)
            return true
        } catch {
            return false
        }
    }

    // MARK: Internal

    func compareWith(version: Version?) -> RobotUpdateStatus {
        guard let version else {
            return .needsUpdate
        }

        if version >= self.currentVersion {
            return .upToDate
        }

        return .needsUpdate
    }
}
