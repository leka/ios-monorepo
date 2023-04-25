// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

public struct ModuleExample {
    public let name: String
    public let infoPlist: [String: InfoPlist.Value]

    public init(name: String, infoPlist: [String: InfoPlist.Value] = [:]) {
        self.name = name
        self.infoPlist = infoPlist
    }
}

extension Project {

    public static func module(
        name: String,
        platform: Platform,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency],
        examples: [ModuleExample] = []
    ) -> Project {
        let frameworkTargets = makeFrameworkTargets(
            name: name,
            platform: platform,
            product: product,
            dependencies: dependencies)

        let exampleTargets = examples.compactMap { example in
            let appInfoPlist = InfoPlist.base(version: "1.0.0").merging(example.infoPlist) { (_, new) in new }

            let target = Target(
                name: example.name,
                platform: .iOS,
                product: .app,
                bundleId: "io.leka.apf.app.example.\(example.name)",
                deploymentTarget: .iOS(targetVersion: "16.0", devices: .ipad),
                infoPlist: .extendingDefault(with: appInfoPlist),
                sources: ["Examples/\(example.name)/Sources/**"],
                resources: ["Examples/\(example.name)/Resources/**"],
                scripts: TargetScript.linters(),
                dependencies: [.target(name: name)]
            )

            return target
        }

        return Project(
            name: name,
            organizationName: "leka.io",
            targets: frameworkTargets + exampleTargets)
    }

}
