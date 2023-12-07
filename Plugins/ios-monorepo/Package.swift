// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import PackageDescription

let package = Package(
    name: "MyPlugin",
    products: [
        .executable(name: "tuist-my-cli", targets: ["tuist-my-cli"]),
    ],
    targets: [
        .executableTarget(
            name: "tuist-my-cli"
        ),
    ]
)
