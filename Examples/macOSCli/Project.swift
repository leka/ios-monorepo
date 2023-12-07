// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.cli(
    name: "macOSCli",
    version: "1.0.0",
    dependencies: [
        .external(name: "ArgumentParser"),
    ])
