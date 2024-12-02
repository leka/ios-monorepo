// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "FirebaseKit",
    examples: [
        ModuleExample(
            name: "FirebaseKitExample"
        ),
    ],
    dependencies: [
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),

        .external(name: "FirebaseAppCheck"),
        .external(name: "FirebaseCore"),
    ]
)
