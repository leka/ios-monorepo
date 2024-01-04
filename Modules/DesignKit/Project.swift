// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "DesignKit",
    platform: .iOS,
    dependencies: [
        .external(name: "Lottie"),
    ]
)
