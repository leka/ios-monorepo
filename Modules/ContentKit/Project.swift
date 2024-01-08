// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "ContentKit",
    examples: [
        ModuleExample(
            name: "ContentKitExample"
        ),
    ],
    dependencies: [
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .external(name: "Yams"),
    ]
)
