// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(
    name: "BLEKit",
    platform: .iOS,
    dependencies: [
        .external(name: "CombineCoreBluetooth"),
    ],
    examples: [
        ModuleExample(
            name: "BLEKitExample",
            infoPlist: [
                "NSBluetoothAlwaysUsageDescription":
                    "The Leka Updater app needs to use Bluetooth to connect to the Leka robot.",
                "UIBackgroundModes": [
                    "bluetooth-central",
                ],
            ]),
    ])
