// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {

    /// Helper function to create the Project for this ExampleApp
    public static func iOSApp(
        name: String,
        version: String = "1.0.0",
        dependencies: [TargetDependency],
        infoPlist: [String: InfoPlist.Value] = [:]
    ) -> Project {
        let appInfoPlist = InfoPlist.base(version: version).merging(infoPlist) { (_, new) in new }

        let mainTarget = Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: "io.leka.apf.app.\(name)",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: .ipad),
            infoPlist: .extendingDefault(with: appInfoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "io.leka.apf.app.\(name)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            scripts: TargetScript.linters(),
            dependencies: [
                .target(name: "\(name)")
            ])

        let targets = [mainTarget, testTarget]

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: targets)
    }

    /// Helper function to create the Project for this ExampleApp
    public static func macOSApp(
        name: String,
        version: String = "1.0.0",
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
                .target(name: "\(name)")
            ])

        let targets = [mainTarget, testTarget]

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: targets)
    }

    /// Helper function to create the Project for this ExampleApp
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

    /// Helper function to create the Project for this ExampleApp
    public static func module(
        name: String, platform: Platform, product: Product = .staticLibrary, dependencies: [TargetDependency]
    ) -> Project {
        let targets = makeFrameworkTargets(
            name: name,
            platform: platform,
            product: product,
            dependencies: dependencies)

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: targets)
    }

    //
    // MARK: - Private
    //

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(
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

    //    /// Helper function to create the application target and the unit test target.
    //    private static func makeAppTargets(
    //        name: String, platform: Platform, dependencies: [TargetDependency], infoPlist: [String: InfoPlist.Value] = [:]
    //    ) -> [Target] {
    //        let platform: Platform = platform
    //        let base: [String: InfoPlist.Value] = [
    //            "CFBundleShortVersionString": "1.0",
    //            "CFBundleVersion": "1",
    //            "UIMainStoryboardFile": "",
    //            "UILaunchStoryboardName": "LaunchScreen",
    //            "ITSAppUsesNonExemptEncryption": "NO",
    //        ]
    //
    //        let global = base.merging(infoPlist) { (_, new) in new }
    //
    //        let mainTarget = Target(
    //            name: name,
    //            platform: platform,
    //            product: .app,
    //            bundleId: "io.leka.apf.app.\(name)",
    //            deploymentTarget: .iOS(targetVersion: "16.0", devices: .ipad),
    //            infoPlist: .extendingDefault(with: global),
    //            sources: ["Sources/**"],
    //            resources: ["Resources/**"],
    //            scripts: TargetScript.linters(),
    //            dependencies: dependencies
    //        )
    //
    //        let testTarget = Target(
    //            name: "\(name)Tests",
    //            platform: platform,
    //            product: .unitTests,
    //            bundleId: "io.leka.apf.app.\(name)Tests",
    //            infoPlist: .default,
    //            sources: ["Tests/**"],
    //            resources: [],
    //            scripts: TargetScript.linters(),
    //            dependencies: [
    //                .target(name: "\(name)")
    //            ])
    //        return [mainTarget, testTarget]
    //    }
}
