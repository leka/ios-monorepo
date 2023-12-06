// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

public extension InfoPlist {
    static func base(version: String) -> [String: InfoPlist.Value] {
        [
            "CFBundleShortVersionString": "\(version)",
            "CFBundleVersion": "\(version)",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "ITSAppUsesNonExemptEncryption": "NO",
        ]
    }
}
