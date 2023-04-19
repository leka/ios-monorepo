// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {

    //
    // MARK: - Internal
    //

    internal static func makeFrameworkTargets(
        name: String, platform: Platform, product: Product = .staticLibrary, dependencies: [TargetDependency]
    )
        -> [Target]
    {
        // MARK: - Set product type
        var product = product

        let generateModulesAsFrameworksForDebug = Environment.generateModulesAsFrameworksForDebug.getBoolean(
            default: false)

        if generateModulesAsFrameworksForDebug {
            product = .framework
        }

        // MARK: - Set platform type
        var platform = platform

        let generateMacOSApps = Environment.generateMacOSApps.getBoolean(default: false)

        if generateMacOSApps {
            platform = .macOS
        }

        let module = Target(
            name: "\(name)",
            platform: platform,
            product: product,
            bundleId: "io.leka.apf.module.\(name)",
            deploymentTarget: platform == .iOS
                ? .iOS(targetVersion: "16.0", devices: .ipad) : .macOS(targetVersion: "13.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies)

        let tests = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "io.leka.apf.framework.\(name)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            scripts: TargetScript.linters(),
            dependencies: [.target(name: name)])

        return [module, tests]
    }

}
