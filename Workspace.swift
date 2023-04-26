// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

func projects() -> [Path] {
    // MARK: - iOS Apps
    let iOSApps: [Path] = [
        "Apps/LekaApp",
        "Apps/LekaUpdater",
        "Apps/LekaActivityUIExplorer",
    ]

    // MARK: - macOS Apps
    let macOSApps: [Path] = [
        // no apps yet
    ]

    // MARK: - Modules
    let modules: [Path] = [
        "Modules/DesignKit"
    ]

    // MARK: - iOS Examples
    let iOSExamples: [Path] = [
        "Examples/iOSApp",
        "Examples/Module",
    ]

    // MARK: - macOS Examples
    let macOSExamples: [Path] = [
        "Examples/macOSApp",
        "Examples/macOSCli",
        "Examples/Module",
    ]

    var projects = iOSApps + modules + iOSExamples

    let generateMacOSApps = Environment.generateMacOSApps.getBoolean(default: false)

    if generateMacOSApps {
        projects = macOSApps + modules + macOSExamples
    }

    return projects
}

let workspace = Workspace(
    name: "ios-monorepo",
    projects: projects()
)
