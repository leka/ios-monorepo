// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.macOSApp(
    name: "macOSApp",
    version: "1.0.0",
    dependencies: [
        .project(target: "Module", path: Path("../../Examples/Module")),
    ]
)
