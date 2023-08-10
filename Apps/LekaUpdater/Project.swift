// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.iOSApp(
    name: "LekaUpdater",
    version: "1.4.0",
    dependencies: [
        .project(target: "DesignKit", path: Path("../../Modules/DesignKit")),
        .project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
    ],
    infoPlist: [
        "LEKA_OS_VERSION": "1.4.0",
        "NSBluetoothAlwaysUsageDescription":
            "The Leka Updater app needs to use Bluetooth to connect to the Leka robot.",
        "UIRequiresFullScreen": "true",
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UISupportedInterfaceOrientations~ipad": [
            "UIInterfaceOrientationPortrait",
            "UIInterfaceOrientationPortraitUpsideDown",
        ],
        "LSApplicationCategoryType": "public.app-category.utilities",
        "NSAccentColorName": "AccentColor",
        "UIBackgroundModes": [
            "external-accessory", "bluetooth-central", "bluetooth-peripheral", "fetch", "processing",
        ],
    ]
)
