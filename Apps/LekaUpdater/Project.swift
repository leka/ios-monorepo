// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let kLekaUpdaterVersion = "1.4.1"

let project = Project.app(
    name: "LekaUpdater",
    version: kLekaUpdaterVersion,
    infoPlist: [
        "LEKA_OS_VERSION": "1.4.0",
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UISupportedInterfaceOrientations~ipad": [
            "UIInterfaceOrientationPortrait",
            "UIInterfaceOrientationPortraitUpsideDown",
        ],
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "io.leka.apf.LekaUpdater",
                "CFBundleURLSchemes": ["LekaUpdater"],
            ],
        ],
        "LSApplicationQueriesSchemes": [
            "LekaApp", "com.googleusercontent.apps.224911845933-mv4tp4rstgjtvdqvbv5dl7defii1a7ic",
        ],
        "UIBackgroundModes": [
            "bluetooth-central",
        ],
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
    ]
)
