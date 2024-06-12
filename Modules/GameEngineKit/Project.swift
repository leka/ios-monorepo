// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "GameEngineKit",
    examples: [
        ModuleExample(
            name: "GameEngineKitExample"
        ),
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .project(target: "ContentKit", path: Path("../../Modules/ContentKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .project(target: "AccountKit", path: Path("../../Modules/AccountKit")),
        .project(target: "UtilsKit", path: Path("../../Modules/UtilsKit")),
        .external(name: "SwiftUIJoystick"),
        .external(name: "AudioKit"),
        .external(name: "SVGView"),
    ]
)
