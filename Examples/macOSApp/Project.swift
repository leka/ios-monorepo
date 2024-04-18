// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "macOSApp",
    deploymentTargets: .macOS("13.0"),
    dependencies: [
        .project(target: "Module", path: Path("../../Examples/Module")),
    ]
)
