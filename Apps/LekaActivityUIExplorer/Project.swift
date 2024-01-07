// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.iOSApp(
    name: "LekaActivityUIExplorer",
    deploymentTarget: .iOS(targetVersion: "17.0", devices: .ipad),
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "GameEngineKit", path: Path("../../Modules/GameEngineKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .external(name: "MarkdownUI"),
        .external(name: "Yams"),
        .external(name: "Lottie"),
        .external(name: "SwiftUIJoystick"),
    ],
    infoPlist: [
        "CFBundleShortVersionString": "1.0.0",
        "CFBundleDocumentTypes": [
            [
                "CFBundleTypeName": "Sequencing Card Item",
                "LSHandlerRank": "Default",
                "CFBundleTypeRole": "Viewer",
                "LSItemContentTypes": [
                    "io.leka.apf.app.uiexplorer.sequencing.card_item",
                ],
            ],
        ],
        "NSBluetoothAlwaysUsageDescription":
            "The Leka App needs to use Bluetooth to connect to the Leka robot.",
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
        "NSAccentColorName": "AccentColor",
    ]
)
