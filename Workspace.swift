// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

let workspace = Workspace(
    name: "ios-monorepo",
    projects: [
        // MARK: - Apps
        "Apps/LekaApp",
        "Apps/LekaEmotions",
        "Apps/LekaUpdater",
        "Apps/LekaActivityUIExplorer",

        // MARK: - Modules
        "Modules/CoreUI",
    ]
)
