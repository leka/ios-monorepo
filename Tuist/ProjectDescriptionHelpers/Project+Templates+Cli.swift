// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

extension Project {

    public static func cli(
        name: String,
        version: String = "1.0.0",
        dependencies: [TargetDependency]
    ) -> Project {
        let mainTarget = Target(
            name: name,
            platform: .macOS,
            product: .commandLineTool,
            bundleId: "io.leka.apf.cli.\(name)",
            deploymentTarget: .macOS(targetVersion: "13.0"),
            sources: ["Sources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies
        )

        let targets = [mainTarget]

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: targets)
    }

}
