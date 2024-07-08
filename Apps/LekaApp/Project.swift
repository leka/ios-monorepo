// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let kLekaAppVersion: String = {
    guard Environment.productionBuild.getBoolean(default: false) else {
        return "999.999.999"
    }

    // ? App version
    return "1.9.0"
}()

let project = Project.app(
    name: "LekaApp",
    version: kLekaAppVersion,
    infoPlist: [
        "LSApplicationCategoryType": "public.app-category.education",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "io.leka.apf.app.LekaApp",
                "CFBundleURLSchemes": ["LekaApp"],
            ],
        ],
        "LSApplicationQueriesSchemes": ["LekaUpdater"],
        "UIBackgroundModes": [
            "bluetooth-central",
            "audio",
        ],
    ],
    settings: [
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    ],
    dependencies: [
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "AnalyticsKit", path: Path("../../Modules/AnalyticsKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "GameEngineKit", path: Path("../../Modules/GameEngineKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .external(name: "Yams"),
        .external(name: "MarkdownUI"),
        .external(name: "Fit"),
        .external(name: "DeviceKit"),
    ]
)
