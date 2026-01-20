// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "AccountKit",
    examples: [
        ModuleExample(
            name: "AccountKitExample"
        ),
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),

        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseAuthCombine-Community"),
        .external(name: "FirebaseFirestore"),
        .external(name: "Version"),
        .external(name: "Yams"),
    ]
)
