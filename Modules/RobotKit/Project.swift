// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "RobotKit",
    platform: .iOS,
    dependencies: [
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
    ],
    examples: [
        ModuleExample(
            name: "RobotKitExample",
            infoPlist: [
                "NSBluetoothAlwaysUsageDescription":
                    "The Leka Updater app needs to use Bluetooth to connect to the Leka robot.",
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
    ])
