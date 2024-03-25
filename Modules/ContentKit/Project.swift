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
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),

        .external(name: "AudioKit"),
        .external(name: "Fit"),
        .external(name: "MarkdownUI"),
        .external(name: "SVGView"),
        .external(name: "SwiftUIJoystick"),
        .external(name: "Version"),
        .external(name: "Yams"),
    ]
)
