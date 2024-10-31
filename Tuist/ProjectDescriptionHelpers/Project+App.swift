// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

public extension Project {
    static func app(
        name: String,
        version: String = "1.0.0",
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets = .iOS("16.6"),
        destinations: Destinations = [.iPad, .macWithiPadDesign],
        infoPlist: [String: Plist.Value] = [:],
        settings: SettingsDictionary = [:],
        launchArguments: [LaunchArgument] = [],
        options: Options = .options(),
        dependencies: [TargetDependency] = [],
        schemes: [Scheme] = []
    ) -> Project {
        let mainTarget = Target.target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: bundleId ?? "io.leka.apf.app.\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: InfoPlist.extendingBase(version: version, with: infoPlist)),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies,
            settings: .settings(base: .extendingBase(with: settings)),
            environmentVariables: [
                "IDEPreferLogStreaming": "YES",
            ],
            launchArguments: launchArguments
        )

        let testTarget = Target.target(
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

        return Project(
            name: name,
            organizationName: "leka.io",
            options: options,
            targets: [
                mainTarget,
                testTarget,
            ],
            schemes: l10nSchemes(name: name) + schemes
        )
    }
}
