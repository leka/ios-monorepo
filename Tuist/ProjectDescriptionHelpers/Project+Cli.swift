// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension Project {
    static func cli(
        name: String,
        version _: String = "1.0.0",
        dependencies: [TargetDependency]
    ) -> Project {
        let mainTarget = Target.target(
            name: name,
            destinations: .macOS,
            product: .commandLineTool,
            bundleId: "io.leka.apf.cli.\(name)",
            deploymentTargets: .macOS("13.0"),
            sources: ["Sources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies
        )

        let targets = [mainTarget]

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: targets
        )
    }
}
