// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension InfoPlist {
    static func base(version: String) -> [String: Plist.Value] {
        [
            "CFBundleShortVersionString": "\(version)",
            "CFBundleVersion": "\(version)",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "ITSAppUsesNonExemptEncryption": "NO",
            "CFBundleLocalizations": [
                "fr",
                "en",
            ],
            "NSBluetoothAlwaysUsageDescription":
                "The app needs to use Bluetooth to connect to the Leka robot",
            "UIBackgroundModes": [
                "bluetooth-central",
                "audio",
            ],
            "UIRequiresFullScreen": "true",
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationLandscapeRight",
                "UIInterfaceOrientationLandscapeLeft",
            ],
            "UISupportedInterfaceOrientations~ipad": [
                "UIInterfaceOrientationLandscapeRight",
                "UIInterfaceOrientationLandscapeLeft",
            ],
        ]
    }

    static func extendingBase(version: String, with plist: [String: Plist.Value]) -> [String: Plist.Value] {
        self.base(version: version).merging(plist) { _, new in new }
    }
}
