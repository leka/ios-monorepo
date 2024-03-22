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
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .external(name: "Version"),
        .external(name: "Yams"),
        .external(name: "MarkdownUI"),
        .external(name: "Fit"),
    ]
)
