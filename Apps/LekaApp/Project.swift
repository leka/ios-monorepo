// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let kLekaAppVersion: String = if Environment.productionBuild.getBoolean(default: false) {
    "1.13.0"
} else {
    "99.00.00"
}

let kLekaAppBundleName: String = if Environment.productionBuild.getBoolean(default: false) {
    "Leka"
} else {
    "Leka Beta"
}

let kLekaAppBundleIdentifier: String = if Environment.productionBuild.getBoolean(default: false) {
    "io.leka.apf.app.LekaApp"
} else {
    "io.leka.apf.app.LekaApp.beta"
}

let kLekaAppBundleURLSchemes: String = if Environment.productionBuild.getBoolean(default: false) {
    "LekaApp"
} else {
    "LekaAppBeta"
}

let kLekaAppIconName: String = if Environment.productionBuild.getBoolean(default: false) {
    "AppIcon"
} else {
    "AppIconBeta"
}

let kLekaAppLaunchArguments: [LaunchArgument] = if Environment.productionBuild.getBoolean(default: false) {
    [
        .launchArgument(name: "-FIRDebugEnabled", isEnabled: false),
        .launchArgument(name: "-FIRDebugDisabled", isEnabled: true),
        .launchArgument(name: "-FIRAnalyticsDebugEnabled", isEnabled: false),
        .launchArgument(name: "-FIRAnalyticsDebugDisabled", isEnabled: true),
    ]
} else {
    [
        .launchArgument(name: "-FIRDebugEnabled", isEnabled: true),
        .launchArgument(name: "-FIRDebugDisabled", isEnabled: false),
        .launchArgument(name: "-FIRAnalyticsDebugEnabled", isEnabled: true),
        .launchArgument(name: "-FIRAnalyticsDebugDisabled", isEnabled: false),
    ]
}

let project = Project.app(
    name: "LekaApp",
    version: kLekaAppVersion,
    bundleId: kLekaAppBundleIdentifier,
    infoPlist: [
        "LSApplicationCategoryType": "public.app-category.education",
        "CFBundleName": "\(kLekaAppBundleName)",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "\(kLekaAppBundleIdentifier)",
                "CFBundleURLSchemes": ["\(kLekaAppBundleURLSchemes)"],
            ],
        ],
        "LSApplicationQueriesSchemes": ["LekaUpdater"],
        "UIBackgroundModes": [
            "bluetooth-central",
            "audio",
        ],
    ],
    settings: SettingsDictionary.extendingBase(with: [
        "ASSETCATALOG_COMPILER_APPICON_NAME": "\(kLekaAppIconName)",
    ]),
    launchArguments: kLekaAppLaunchArguments,
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
