// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "ContentKit",
    platform: .iOS,
    dependencies: [
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .external(name: "Yams"),
    ],
    examples: [
        ModuleExample(
            name: "ContentKitExample",
            infoPlist: [
                "NSAccentColorName": "AccentColor",
            ]),
    ])
