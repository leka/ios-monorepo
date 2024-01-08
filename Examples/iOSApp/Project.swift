// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "iOSApp",
    dependencies: [
        .project(target: "Module", path: Path("../../Examples/Module")),
    ]
)
