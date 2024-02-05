// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "AccountKit",
    examples: [
        ModuleExample(
            name: "AccountKitExample"
        ),
    ],
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "LogKit", path: Path("../../Modules/LogKit")),
        .project(target: "LocalizationKit", path: Path("../../Modules/LocalizationKit")),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseAuthCombine-Community"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseFirestoreSwift"),
        .external(name: "FirebaseFirestoreCombine-Community"),
    ]
)
