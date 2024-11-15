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
        .project(target: "AnalyticsKit", path: Path("../../Modules/AnalyticsKit")),
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "UtilsKit", path: Path("../../Modules/UtilsKit")),

        .external(name: "Version"),
    ]
)
