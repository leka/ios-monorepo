// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

var projects: [Path] {
    // MARK: - iOS Apps

    let iOSApps: [Path] = [
        "Apps/LekaApp",
        "Apps/LekaUpdater",
    ]

    // MARK: - macOS Apps

    let macOSApps: [Path] = [
        // no apps yet
    ]

    // MARK: - Modules

    let modules: [Path] = [
        "Modules/AccountKit",
        "Modules/BLEKit",
        "Modules/ContentKit",
        "Modules/DesignKit",
        "Modules/GameEngineKit",
        "Modules/LocalizationKit",
        "Modules/LogKit",
        "Modules/RobotKit",
        "Modules/UtilsKit",
    ]

    // MARK: - iOS Examples

    let iOSExamples: [Path] = if Environment.generateExamples.getBoolean(default: false) {
        [
            "Examples/iOSApp",
            "Examples/Module",
        ]
    } else { [] }

    // MARK: - macOS Examples

    let macOSExamples: [Path] = if Environment.generateExamples.getBoolean(default: false) {
        [
            "Examples/macOSApp",
            "Examples/macOSCli",
            "Examples/Module",
        ]
    } else { [] }

    var projects = iOSApps + modules + iOSExamples

    if Environment.generateMacOSApps.getBoolean(default: false) {
        projects = macOSApps + modules + macOSExamples
    }

    return projects
}

let workspace = Workspace(
    name: "ios-monorepo",
    projects: projects
)
