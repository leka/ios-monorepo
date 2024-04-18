// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.cli(
    name: "macOSCli",
    version: "1.0.0",
    dependencies: [
        .external(name: "ArgumentParser"),
    ]
)
