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

    // MARK: - Modules

    let modules: [Path] = [
        "Modules/AccountKit",
        "Modules/AnalyticsKit",
        "Modules/BLEKit",
        "Modules/ContentKit",
        "Modules/DesignKit",
        "Modules/FirebaseKit",
        "Modules/LocalizationKit",
        "Modules/LogKit",
        "Modules/RobotKit",
        "Modules/UtilsKit",
    ]

    let projects = iOSApps + modules

    return projects
}

let workspace = Workspace(
    name: "ios-monorepo",
    projects: projects
)
