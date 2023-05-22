// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.iOSApp(
    name: "LekaActivityUIExplorer",
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .external(name: "MarkdownUI"),
        .external(name: "Yams"),
        .external(name: "Lottie"),
        .external(name: "SwiftUIJoystick"),
    ],
    infoPlist: [
        "CFBundleShortVersionString": "1.0.0",
        "NSBluetoothAlwaysUsageDescription":
            "The Leka App needs to use Bluetooth to connect to the Leka robot.",
        "UIRequiresFullScreen": "true",
        "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationLandscapeRight",
            "UIInterfaceOrientationLandscapeLeft",
        ],
        "UISupportedInterfaceOrientations~ipad": [
            "UIInterfaceOrientationLandscapeRight",
            "UIInterfaceOrientationLandscapeLeft",
        ],
        "NSAccentColorName": "AccentColor",
    ])
