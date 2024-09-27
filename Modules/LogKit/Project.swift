// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "LogKit",
    examples: [
        ModuleExample(
            name: "LogKitExample"
        ),
    ],
    dependencies: [
        .project(target: "UtilsKit", path: Path("../../Modules/UtilsKit")),

        .external(name: "Logging"),
    ]
)
