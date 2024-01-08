// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "RobotKit",
    examples: [
        ModuleExample(
            name: "RobotKitExample"
        ),
    ],
    dependencies: [
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .external(name: "Version"),
    ]
)
