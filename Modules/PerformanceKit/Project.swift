// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "PerformanceKit",
    examples: [
        ModuleExample(
            name: "PerformanceKitExample"
        ),
    ],
    dependencies: [
        .project(target: "FirebaseKit", path: Path("../../Modules/FirebaseKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
    ]
)
