// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let kLekaApp: App = if Environment.productionBuild.getBoolean(
    default: false
) {
    .init(
        version: "1.14.0",
        bundleId: "io.leka.apf.app.LekaApp",
        name: "Leka",
        urlSchemes: "LekaApp",
        appIcon: "AppIcon"
    )
} else {
    .init(
        version: "99.00.00",
        bundleId: "io.leka.apf.app.LekaApp.beta",
        name: "Leka Beta",
        urlSchemes: "LekaAppBeta",
        appIcon: "AppIconBeta"
    )
}

let project = Project.app(
    name: "LekaApp",
    version: kLekaApp.version,
    bundleId: kLekaApp.bundleId,
    infoPlist: [
        "LSApplicationCategoryType": "public.app-category.education",
        "CFBundleName": "\(kLekaApp.name)",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "\(kLekaApp.bundleId)",
                "CFBundleURLSchemes": ["\(kLekaApp.urlSchemes)"],
            ],
        ],
        "LSApplicationQueriesSchemes": ["LekaUpdater"],
        "UIBackgroundModes": [
            "bluetooth-central",
            "audio",
        ],
        "FirebaseAutomaticScreenReportingEnabled": "NO",
    ],
    settings: SettingsDictionary.extendingBase(with: [
        "ASSETCATALOG_COMPILER_APPICON_NAME": "\(kLekaApp.appIcon)",
    ]),
    dependencies: [
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "GameEngineKit", path: Path("../../Modules/GameEngineKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "UtilsKit", path: Path("../../Modules/UtilsKit")),

        .external(name: "AppUpdately"),
        .external(name: "DeviceKit"),
        .external(name: "Fit"),
        .external(name: "MarkdownUI"),
        .external(name: "Yams"),
    ]
)
