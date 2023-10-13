// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CryptoKit
import Foundation
import Version

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

    @Published public var data = Data()

    public var sha256: String {
        SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
    }

    func compareWith(version: String) -> RobotUpdateStatus {
        guard let version = Version(version) else {
            return .needsUpdate
        }

        if version >= Version(currentVersion)! {
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
