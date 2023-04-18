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
        let sources4iOS = Target(
            name: "\(name)",
            platform: platform,
            product: product,
            bundleId: "io.leka.apf.framework.iOS.\(name)",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: .ipad),
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

        return [sources4iOS, tests]
    }

}
