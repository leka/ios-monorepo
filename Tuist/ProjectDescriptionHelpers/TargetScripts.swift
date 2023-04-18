// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

extension TargetScript {
    public static let swiftLint = TargetScript.post(
        path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLint",
        basedOnDependencyAnalysis: false)

    public static let swiftFormat = TargetScript.post(
        path: Path.relativeToRoot("Scripts/SwiftFormatRunScript.sh"),
        name: "SwiftFormat",
        basedOnDependencyAnalysis: false)

    public static func linters() -> [TargetScript] {

        let turnOffLinters = Environment.turnOffLinters.getBoolean(default: false)

        let defaultLinters: [TargetScript] = [
            .swiftLint,
            .swiftFormat,
        ]

        if turnOffLinters {
            return []
        }

        return defaultLinters
    }

}
