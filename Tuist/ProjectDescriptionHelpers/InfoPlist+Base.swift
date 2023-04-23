// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

extension InfoPlist {

    public static func base(version: String) -> [String: InfoPlist.Value] {
        return [
            "CFBundleShortVersionString": "\(version)",
            "CFBundleVersion": "\(version)",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "ITSAppUsesNonExemptEncryption": "NO",
        ]
    }

}
