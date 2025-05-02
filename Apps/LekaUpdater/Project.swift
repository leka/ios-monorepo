// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let kLekaUpdaterVersion: String = {
    guard Environment.productionBuild.getBoolean(default: false) else {
        return "999.999.999"
    }

    // ? App version
    return "2.0.0"
}()

let project = Project.app(
    name: "LekaUpdater",
    version: kLekaUpdaterVersion,
    infoPlist: [
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
    options: .options(
        defaultKnownRegions: ["fr", "en"],
        developmentRegion: "en"
    ),
    dependencies: [
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),

        .external(name: "Version"),
    ]
)
