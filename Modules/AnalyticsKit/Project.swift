// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "AnalyticsKit",
    examples: [
        ModuleExample(
            name: "AnalyticsKitExample"
        ),
    ],
    dependencies: [
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
    ]
)
