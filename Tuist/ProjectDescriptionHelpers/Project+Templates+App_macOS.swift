// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

public extension Project {
    static func macOSApp(
        name: String,
        version _: String = "1.0.0",
        dependencies: [TargetDependency]
    ) -> Project {
        let mainTarget = Target(
            name: name,
            platform: .macOS,
            product: .app,
            bundleId: "io.leka.apf.app.\(name)",
            deploymentTarget: .macOS(targetVersion: "13.0"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: .macOS,
            product: .unitTests,
            bundleId: "io.leka.apf.app.\(name)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            scripts: TargetScript.linters(),
            dependencies: [
                .target(name: "\(name)"),
            ]
        )

        let targets = [mainTarget, testTarget]

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: targets
        )
    }
}
