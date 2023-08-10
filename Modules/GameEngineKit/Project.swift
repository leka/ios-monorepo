// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "GameEngineKit",
    platform: .iOS,
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .external(name: "SwiftUIJoystick"),
        .external(name: "AudioKit"),
    ],
    examples: [
        ModuleExample(
            name: "GameEngineKitExample"
        )
    ])
