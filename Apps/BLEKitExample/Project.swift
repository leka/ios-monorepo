// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.iOSApp(
    name: "BLEKitExample",
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
    ],
    infoPlist: [
        "NSBluetoothAlwaysUsageDescription":
            "The LekaBLE app needs to use Bluetooth to connect to the Leka robot."
    ])
