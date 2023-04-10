// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

extension TargetScript {
    public static let swiftLint = TargetScript.pre(
        path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLint",
        basedOnDependencyAnalysis: false)

    public static let swiftFormat = TargetScript.pre(
        path: Path.relativeToRoot("Scripts/SwiftFormatRunScript.sh"),
        name: "SwiftFormat",
        basedOnDependencyAnalysis: false)
}
