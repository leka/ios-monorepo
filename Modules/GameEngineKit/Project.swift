// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "GameEngineKit",
    platform: .iOS,
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .external(name: "SwiftUIJoystick"),
        .external(name: "AudioKit"),
    ],
    examples: [
        ModuleExample(
            name: "GameEngineKitExample",
            infoPlist: [
                "NSBluetoothAlwaysUsageDescription":
                    "The Leka Updater app needs to use Bluetooth to connect to the Leka robot.",
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
            ]
        ),
    ])
