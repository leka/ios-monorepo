// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "BLEKit",
    examples: [
        ModuleExample(
            name: "BLEKitExample"
        ),
    ],
    dependencies: [
        .external(name: "CombineCoreBluetooth"),
    ]
)
