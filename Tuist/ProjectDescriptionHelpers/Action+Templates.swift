// Leka - iOS Monorepo
// Copyright 2023 APF Frdance handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

public extension TargetScript {
	static let swiftLint = TargetScript.pre(
		path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
		name: "SwiftLint",
		basedOnDependencyAnalysis: false)
}
