// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import ProjectDescription

// MARK: - ModuleExample

public struct ModuleExample {
    // MARK: Lifecycle

    public init(name: String, infoPlist: [String: Plist.Value] = [:], dependencies: [TargetDependency] = []) {
        self.name = name
        self.infoPlist = infoPlist
        self.dependencies = dependencies
    }

    // MARK: Public

    public let name: String
    public let infoPlist: [String: Plist.Value]
    public let dependencies: [TargetDependency]
}

public extension Project {
    static func module(
        name: String,
        deploymentTargets: DeploymentTargets = .iOS("17.4"),
        destinations: Destinations = [.iPad, .macWithiPadDesign],
        infoPlist: [String: Plist.Value] = [:],
        settings: SettingsDictionary = [:],
        options: Options = .options(),
        examples: [ModuleExample] = [],
        dependencies: [TargetDependency] = [],
        schemes: [Scheme] = []
    ) -> Project {
        let frameworkTargets = makeFrameworkTargets(
            name: name,
            deploymentTargets: deploymentTargets,
            destinations: destinations,
            infoPlist: infoPlist,
            settings: settings,
            dependencies: dependencies
        )

        let exampleTargets: [Target] = if Environment.generateExampleTargets.getBoolean(default: false) {
            examples.compactMap { example in
                Target.target(
                    name: example.name,
                    destinations: destinations,
                    product: .app,
                    bundleId: "io.leka.apf.app.example.\(example.name)",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .extendingDefault(with: InfoPlist.extendingBase(version: "1.0.0", with: infoPlist)),
                    sources: ["Examples/\(example.name)/Sources/**"],
                    resources: ["Examples/\(example.name)/Resources/**"],
                    scripts: TargetScript.linters(),
                    dependencies: [.target(name: name)] + example.dependencies,
                    settings:
                    .settings(base:
                        .extendingBase(with: settings)
                            .merging(SettingsDictionary.manualCodeSigning)
                    )
                )
            }
        } else {
            []
        }

        return Project(
            name: name,
            organizationName: "leka.io",
            options: options,
            targets: frameworkTargets + exampleTargets,
            schemes: schemes
        )
    }
}

private func makeFrameworkTargets(
    name: String,
    deploymentTargets: DeploymentTargets = .iOS("17.4"),
    destinations: Destinations = [.iPad, .macWithiPadDesign],
    infoPlist: [String: Plist.Value] = [:],
    settings: SettingsDictionary = [:],
    dependencies: [TargetDependency] = []
)
    -> [Target]
{
    let product: Product = if Environment.generateModulesAsFrameworksForDebug.getBoolean(
        default: false
    ) {
        .framework
    } else {
        .staticFramework
    }

    let module = Target.target(
        name: name,
        destinations: destinations,
        product: product,
        bundleId: "io.leka.apf.module.\(name)",
        deploymentTargets: deploymentTargets,
        infoPlist: .extendingDefault(with: InfoPlist.extendingBase(version: "1.0.0", with: infoPlist)),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        scripts: TargetScript.linters(),
        dependencies: dependencies,
        settings: .settings(base: .extendingBase(with: settings))
    )

    let tests = Target.target(
        name: "\(name)Tests",
        destinations: destinations,
        product: .unitTests,
        bundleId: "io.leka.apf.framework.\(name)Tests",
        infoPlist: .extendingDefault(with: InfoPlist.extendingBase(version: "1.0.0", with: infoPlist)),
        sources: ["Tests/**"],
        resources: [],
        scripts: TargetScript.linters(),
        dependencies: [
            .target(name: "\(name)"),
        ] + dependencies
    )

    return [module, tests]
}
