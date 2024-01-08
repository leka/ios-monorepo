// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "LocalizationKit",
    examples: [
        ModuleExample(
            name: "LocalizationKitExample",
            infoPlist: [
                "NSAccentColorName": "AccentColor",
            ]
        ),
    ],
    dependencies: [
        // no deps
    ],
    schemes: [
        SchemeList.l10nFR(name: "LocalizationKitExample"),
        SchemeList.l10nEN(name: "LocalizationKitExample"),
    ]
)
