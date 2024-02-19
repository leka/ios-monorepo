// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "LekaApp",
    version: "1.0.0",
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
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .external(name: "Yams"),
        .external(name: "MarkdownUI"),
    ]
)
