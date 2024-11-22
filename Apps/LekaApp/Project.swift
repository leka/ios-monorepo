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
        version: "1.14.4",
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

let kLekaAppFirebaseInfoPlistPath: ResourceFileElement = if Environment.productionBuild.getBoolean(
    default: false
) {
    "GoogleFirebase/PROD/GoogleService-Info.plist"
} else if Environment.testflightBuild.getBoolean(
    default: false
) {
    "GoogleFirebase/TESTFLIGHT/GoogleService-Info.plist"
} else {
    "GoogleFirebase/DEV/GoogleService-Info.plist"
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
        "FirebaseAutomaticScreenReportingEnabled": false,
    ],
    resources: [kLekaAppFirebaseInfoPlistPath],
    settings: SettingsDictionary.extendingBase(with: [
        "ASSETCATALOG_COMPILER_APPICON_NAME": "\(kLekaApp.appIcon)",
    ]),
    dependencies: [
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "AnalyticsKit", path: Path("../../Modules/AnalyticsKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "FirebaseKit", path: Path("../../Modules/FirebaseKit")),
        .project(target: "GameEngineKit", path: Path("../../Modules/GameEngineKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "UtilsKit", path: Path("../../Modules/UtilsKit")),
        .external(name: "DeviceKit"),
        .external(name: "Fit"),
        .external(name: "MarkdownUI"),
        .external(name: "Yams"),
    ]
)
