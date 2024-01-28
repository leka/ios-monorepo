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
        .external(name: "Yams"),
    ]
)
