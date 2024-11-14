// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "ContentKit",
    examples: [
        ModuleExample(
            name: "ContentKitExample",
            dependencies: [
                .external(name: "MarkdownUI"),
            ]
        ),
    ],
    dependencies: [
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "AnalyticsKit", path: Path("../../Modules/AnalyticsKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "UtilsKit", path: Path("../../Modules/UtilsKit")),

        .external(name: "Fit"),
        .external(name: "MarkdownUI"),
        .external(name: "Version"),
        .external(name: "Yams"),
        .external(name: "YouTubePlayerKit"),
    ]
)
