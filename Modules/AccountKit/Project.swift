// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "AccountKit",
    platform: .iOS,
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
    ],
    examples: [
        ModuleExample(
            name: "AccountKitExample",
            infoPlist: [
                "NSAccentColorName": "AccentColor",
            ]
        ),
    ]
)
