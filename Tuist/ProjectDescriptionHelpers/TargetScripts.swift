// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension TargetScript {
    static let swiftLint = TargetScript.post(
        path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )

    static func linters() -> [TargetScript] {
        let turnOffLinters = Environment.turnOffLinters.getBoolean(default: false)

        let defaultLinters: [TargetScript] = [
            .swiftLint,
        ]

        if turnOffLinters {
            return []
        }

        return defaultLinters
    }

//    static let FBCrashlytics = TargetScript.pre(
//        path: "./Scripts/FBCrashlyticsRunScript.sh",
//        name: "Firebase Crashlystics"
//    )
}
