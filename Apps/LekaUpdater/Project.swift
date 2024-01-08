// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

private var schemes: [Scheme] {
    var schemeList: [Scheme] = []

    if Environment.createLocalizationSchemes.getBoolean(
        default: false)
    {
        schemeList.append(contentsOf: [
            SchemeList.l10nFR(name: "LekaUpdater"),
            SchemeList.l10nEN(name: "LekaUpdater"),
        ])
    }

    return schemeList
}

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(
    name: "LekaUpdater",
    version: "1.4.0",
    infoPlist: [
        "LEKA_OS_VERSION": "1.4.0",
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
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .external(name: "Version"),
    ],
    schemes: schemes
)
