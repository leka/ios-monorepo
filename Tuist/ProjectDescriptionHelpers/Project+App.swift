// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension Project {
    static func app(
        name: String,
        version: String = "1.0.0",
        deploymentTargets: DeploymentTargets = .iOS("16.0"),
        destinations: Destinations = [.iPad, .macWithiPadDesign],
        infoPlist: [String: Plist.Value] = [:],
        settings: SettingsDictionary = [:],
        options: Options = .options(),
        dependencies: [TargetDependency] = [],
        schemes: [Scheme] = []
    ) -> Project {
        let mainTarget = Target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "io.leka.apf.app.\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: InfoPlist.extendingBase(version: version, with: infoPlist)),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies,
            settings: .settings(base: .extendingBase(with: settings))
        )

        let testTarget = Target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "io.leka.apf.app.\(name)Tests",
            infoPlist: .extendingDefault(with: InfoPlist.extendingBase(version: version, with: infoPlist)),
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
            options: options,
            targets: targets,
            schemes: schemes
        )
    }
}
