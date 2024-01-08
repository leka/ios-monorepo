// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(
    name: "LekaActivityUIExplorer",
    deploymentTargets: .iOS("17.0"),
    infoPlist: [
        "NSAccentColorName": "AccentColor",
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "GameEngineKit", path: Path("../../Modules/GameEngineKit")),
        .project(target: "RobotKit", path: Path("../../Modules/RobotKit")),
        .external(name: "MarkdownUI"),
        .external(name: "Yams"),
        .external(name: "Lottie"),
        .external(name: "SwiftUIJoystick"),
    ]
)
