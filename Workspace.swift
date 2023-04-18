// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

func projects() -> [Path] {
    var projects: [Path] = [
        // MARK: - Apps
        "Apps/LekaApp",
        "Apps/LekaUpdater",
        "Apps/LekaActivityUIExplorer",

        // MARK: - Modules
        "Modules/DesignKit",
    ]

    let generateExamples = Environment.generateExamples.getBoolean(default: false)

    if generateExamples {
        projects.append(contentsOf: [
            // MARK: - Examples
            "Examples/iOSApp",
            "Examples/macOSApp",
            "Examples/macOSCli",
            "Examples/DynamicLibrary",
        ])
    }

    return projects
}

let workspace = Workspace(
    name: "ios-monorepo",
    projects: projects()
)
