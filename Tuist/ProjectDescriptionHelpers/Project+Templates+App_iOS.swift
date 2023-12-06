// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

public extension Project {
    static func iOSApp(
        name: String,
        version: String = "1.0.0",
        deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: .ipad),
        dependencies: [TargetDependency],
        infoPlist: [String: InfoPlist.Value] = [:],
        options: Options = .options(),
        schemes: [Scheme] = []
    ) -> Project {
        let appInfoPlist = InfoPlist.base(version: version).merging(infoPlist) { (_, new) in new }

        let mainTarget = Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: "io.leka.apf.app.\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: .extendingDefault(with: appInfoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: TargetScript.linters(),
            dependencies: dependencies,
            settings: .settings(base: [
                "LOCALIZED_STRING_MACRO_NAMES": [
                    "NSLocalizedString",
                    "CFCopyLocalizedString",
                    "LocalizedString",
                    "LocalizedStringInterpolation",
                ]
            ])
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
            options: options,
            targets: targets,
            schemes: schemes
        )
    }
}
