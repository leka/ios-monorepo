// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

// MARK: - App

public struct App: Sendable {
    // MARK: Lifecycle

    public init(
        version: String,
        bundleId: String,
        name: String,
        urlSchemes: String,
        appIcon: String
    ) {
        self.version = version
        self.bundleId = bundleId
        self.name = name
        self.urlSchemes = urlSchemes
        self.appIcon = appIcon
    }

    // MARK: Public

    public let version: String
    public let bundleId: String
    public let name: String
    public let urlSchemes: String
    public let appIcon: String
}

public extension Project {
    static func app(
        name: String,
        version: String = "1.0.0",
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets = .iOS("17.4"),
        destinations: Destinations = [.iPad, .macWithiPadDesign],
        infoPlist: [String: Plist.Value] = [:],
        resources: [ResourceFileElement] = [],
        settings: SettingsDictionary = [:],
        launchArguments: [LaunchArgument] = [],
        options: Options = .options(),
        dependencies: [TargetDependency] = [],
        scripts: [TargetScript] = [], // New `scripts` parameter
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
            resources: .resources(["Resources/**"] + resources),
            scripts: TargetScript.linters() + scripts,
            // Combine default scripts with custom scripts
            dependencies: dependencies,
            settings:
            .settings(base:
                .extendingBase(with: settings)
                    .merging(SettingsDictionary.manualCodeSigning)
            ),
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
            dependencies: [.target(name: "\(name)")] + dependencies
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
