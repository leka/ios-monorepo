// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: "Module",
    examples: [
        ModuleExample(name: "ModuleExampleAppOne"),
        ModuleExample(
            name: "ModuleExampleAppTwo",
            infoPlist: [
                "APP_NAME": "ModuleExampleAppTwo from InfoPlist",
            ]
        ),
    ],
    dependencies: [
        // no deps
    ]
)
