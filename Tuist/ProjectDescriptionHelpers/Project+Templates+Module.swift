// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

extension Project {

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

}
