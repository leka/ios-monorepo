// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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

class FirmwareManager: ObservableObject {
    // MARK: Public

    @Published public var data = Data()

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
        SHA256.hash(data: self.data).compactMap { String(format: "%02x", $0) }.joined()
    }

    public func load() -> Bool {
        guard let fileURL = Bundle.main.url(forResource: "LekaOS-\(currentVersion)", withExtension: "bin") else {
            return false
        }

        do {
            self.data = try Data(contentsOf: fileURL)
            return true
        } catch {
            return false
        }
    }

    // MARK: Internal

    let currentVersion = Robot.kLatestFirmwareVersion

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
