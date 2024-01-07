// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.iOSApp(
    name: "LekaApp",
    version: "1.0.0",
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .external(name: "Yams"),
        .external(name: "Lottie"),
    ],
    infoPlist: [
        "NSBluetoothAlwaysUsageDescription":
            "The Leka App needs to use Bluetooth to connect to the Leka robot.",
        "UIBackgroundModes": [
            "bluetooth-central",
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
        "NSAccentColorName": "AccentColor",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "io.leka.apf.app.LekaApp",
                "CFBundleURLSchemes": ["LekaApp"],
            ],
        ],
        "LSApplicationQueriesSchemes": ["LekaUpdater"],
    ]
)
